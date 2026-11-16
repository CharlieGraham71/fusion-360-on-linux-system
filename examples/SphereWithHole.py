# Builds a 50 mm sphere with a 10 mm hole straight through the centre.
# Change the sizes below (in millimetres) and run again if you want different ones.
import adsk.core, adsk.fusion, traceback, math

SPHERE_DIAMETER_MM = 50
HOLE_DIAMETER_MM = 10

def run(context):
    ui = None
    try:
        app = adsk.core.Application.get()
        ui = app.userInterface
        app.documents.add(adsk.core.DocumentTypes.FusionDesignDocumentType)
        design = adsk.fusion.Design.cast(app.activeProduct)
        root = design.rootComponent
        P = adsk.core.Point3D.create
        R = SPHERE_DIAMETER_MM / 20.0   # API works in cm; radius
        r = HOLE_DIAMETER_MM / 20.0

        # Half-circle profile, revolved 360 degrees -> sphere
        sk = root.sketches.add(root.xZConstructionPlane)
        sk.name = 'Sphere profile'
        sk.sketchCurves.sketchArcs.addByThreePoints(P(0, -R, 0), P(R, 0, 0), P(0, R, 0))
        axis = sk.sketchCurves.sketchLines.addByTwoPoints(P(0, -R, 0), P(0, R, 0))
        revs = root.features.revolveFeatures
        rin = revs.createInput(sk.profiles.item(0), axis, adsk.fusion.FeatureOperations.NewBodyFeatureOperation)
        rin.setAngleExtent(False, adsk.core.ValueInput.createByReal(2 * math.pi))
        rev = revs.add(rin)
        rev.bodies.item(0).name = 'Sphere'

        # Circle through the centre, cut both ways -> through hole
        sk2 = root.sketches.add(root.xYConstructionPlane)
        sk2.name = 'Hole'
        sk2.sketchCurves.sketchCircles.addByCenterRadius(P(0, 0, 0), r)
        exts = root.features.extrudeFeatures
        ein = exts.createInput(sk2.profiles.item(0), adsk.fusion.FeatureOperations.CutFeatureOperation)
        ein.setSymmetricExtent(adsk.core.ValueInput.createByReal(2 * R + 0.2), True)
        exts.add(ein)

        app.activeViewport.fit()
    except:
        if ui:
            ui.messageBox('Failed:\n{}'.format(traceback.format_exc()))
