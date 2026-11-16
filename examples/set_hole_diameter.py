# ScriptBridge example: change the through-hole of the SphereWithHole design.
import adsk.fusion
NEW_DIAMETER_MM = 28
design = adsk.fusion.Design.cast(app.activeProduct)
sk = design.rootComponent.sketches.itemByName('Hole')
c = sk.sketchCurves.sketchCircles.item(0)
print('before mm', round(c.radius * 20, 3))
c.radius = NEW_DIAMETER_MM / 20.0   # API units are cm (radius)
design.computeAll()
print('after mm', round(sk.sketchCurves.sketchCircles.item(0).radius * 20, 3))
