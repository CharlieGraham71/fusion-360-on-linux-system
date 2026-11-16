# ScriptBridge example: export the first body of the active design as a binary STL.
import adsk.fusion
OUT = r'Z:\home\graham\fusion-bridge\export.stl'   # Z:\ = Linux root under Wine
design = adsk.fusion.Design.cast(app.activeProduct)
body = design.rootComponent.bRepBodies.item(0)
em = design.exportManager
opts = em.createSTLExportOptions(body, OUT)
opts.meshRefinement = adsk.fusion.MeshRefinementSettings.MeshRefinementHigh
opts.isBinaryFormat = True
print('exported', em.execute(opts), OUT)
