# Monster Fighter — Pyroxi Blender Blockout v0.1
# Run inside Blender's Scripting workspace.
# This creates an original stylized blockout, not the final production mesh.

import bpy
import math
from mathutils import Vector

# Clean scene
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete(use_global=False)

# ---------- Materials ----------

def mat(name, color, metallic=0.0, roughness=0.65):
    m = bpy.data.materials.new(name)
    m.diffuse_color = (*color, 1.0)
    m.metallic = metallic
    m.roughness = roughness
    return m

ember = mat("Pyroxi_Ember", (0.88, 0.20, 0.07))
orange = mat("Pyroxi_Orange", (1.00, 0.36, 0.08))
accent = mat("Pyroxi_Accent", (1.00, 0.67, 0.10))
cream = mat("Pyroxi_Chest", (0.92, 0.72, 0.52))
dark = mat("Pyroxi_Dark", (0.16, 0.055, 0.035))
eye = mat("Pyroxi_Eyes", (0.015, 0.010, 0.008), roughness=0.25)

# ---------- Helpers ----------

def uv(name, location, scale, material, segments=24, rings=16):
    bpy.ops.mesh.primitive_uv_sphere_add(
        segments=segments,
        ring_count=rings,
        location=location,
    )
    o = bpy.context.object
    o.name = name
    o.scale = scale
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    o.data.materials.append(material)
    bpy.ops.object.shade_smooth()
    return o

def cone(name, location, radius1, radius2, depth, material, rotation=(0,0,0)):
    bpy.ops.mesh.primitive_cone_add(
        vertices=16,
        radius1=radius1,
        radius2=radius2,
        depth=depth,
        location=location,
        rotation=rotation,
    )
    o = bpy.context.object
    o.name = name
    o.data.materials.append(material)
    bpy.ops.object.shade_smooth()
    return o

# ---------- Body ----------

body = uv("Pyroxi_Body", (0, 0, 1.65), (0.82, 0.62, 0.72), ember)
head = uv("Pyroxi_Head", (0, -0.18, 2.48), (0.72, 0.66, 0.70), orange)

# Chest marking
uv("Pyroxi_ChestMark", (0, -0.73, 1.68), (0.42, 0.10, 0.45), cream)

# ---------- Legs ----------

leg_data = [
    ("FL", -0.48, -0.34),
    ("FR",  0.48, -0.34),
    ("BL", -0.48,  0.34),
    ("BR",  0.48,  0.34),
]

for side, x, y in leg_data:
    uv("Pyroxi_Leg_" + side, (x, y, 1.08), (0.23, 0.23, 0.48), ember)
    uv("Pyroxi_Paw_" + side, (x, y - 0.10, 0.73), (0.28, 0.34, 0.18), dark)

# ---------- Face ----------

for side, x in [("L", -0.29), ("R", 0.29)]:
    uv("Pyroxi_Eye_" + side, (x, -0.76, 2.58), (0.15, 0.09, 0.17), eye)

# muzzle
uv("Pyroxi_Muzzle", (0, -0.76, 2.34), (0.34, 0.12, 0.23), cream)

# ---------- Ears ----------

for side, x in [("L", -0.47), ("R", 0.47)]:
    ear = cone(
        "Pyroxi_Ear_" + side,
        (x, -0.10, 3.04),
        0.24, 0.035, 0.62,
        accent,
        rotation=(0, math.radians(8 if x < 0 else -8), 0),
    )

# ---------- Ember Tail ----------

tail_base = uv("Pyroxi_TailBase", (0, 0.68, 1.72), (0.27, 0.27, 0.32), orange)

# segmented tail for a curved silhouette
for i, (x, z, s) in enumerate([
    (0.00, 1.95, 0.27),
    (0.00, 2.22, 0.22),
    (0.08, 2.47, 0.18),
]):
    uv("Pyroxi_Tail_" + str(i), (x, 0.88, z), (s, s, s * 1.25), orange)

# flame tip
uv("Pyroxi_EmberTip", (0.08, 0.88, 2.70), (0.20, 0.20, 0.34), accent)

# ---------- Root ----------

bpy.ops.object.empty_add(type='PLAIN_AXES', location=(0,0,0.75))
root = bpy.context.object
root.name = "Pyroxi_Root"

# Parent creature parts to root
for o in list(bpy.context.scene.objects):
    if o is not root and o.type in {'MESH'} and o.name.startswith("Pyroxi_"):
        o.parent = root

# ---------- Ground ----------

bpy.ops.mesh.primitive_plane_add(size=12, location=(0,0,0))
ground = bpy.context.object
ground.name = "Pyroxi_PreviewGround"
ground.data.materials.append(mat("Preview_Ground", (0.055,0.075,0.05)))

# ---------- Camera ----------

bpy.ops.object.camera_add(location=(4.5, -7.0, 3.7))
camera = bpy.context.object
camera.name = "Pyroxi_PreviewCamera"
bpy.context.scene.camera = camera

def look_at(obj, target):
    direction = Vector(target) - obj.location
    obj.rotation_euler = direction.to_track_quat('-Z', 'Y').to_euler()

look_at(camera, (0,0,1.65))
camera.data.lens = 52

# ---------- Lights ----------

bpy.ops.object.light_add(type='AREA', location=(3.5, -4.0, 6.0))
key = bpy.context.object
key.name = "Key_Light"
key.data.energy = 800
key.data.shape = 'DISK'
key.data.size = 4
look_at(key, (0,0,1.5))

bpy.ops.object.light_add(type='AREA', location=(-4.0, -1.5, 3.5))
fill = bpy.context.object
fill.name = "Fill_Light"
fill.data.energy = 450
fill.data.size = 3
look_at(fill, (0,0,1.5))

# ---------- Scene ----------

scene = bpy.context.scene
scene.render.engine = 'BLENDER_EEVEE_NEXT'
scene.render.resolution_x = 700
scene.render.resolution_y = 700
scene.render.resolution_percentage = 100

print("Monster Fighter: Pyroxi blockout created successfully.")
