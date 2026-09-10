#!/usr/bin/env python3
from PIL import Image, ImageDraw

SIZE = 1024
img = Image.new("RGB", (SIZE, SIZE), (30, 90, 200))
draw = ImageDraw.Draw(img)

for y in range(SIZE):
	ratio = y / SIZE
	r = int(30 + (140 - 30) * ratio)
	g = int(90 + (190 - 90) * ratio)
	b = int(200 + (250 - 200) * ratio)
	draw.line([(0, y), (SIZE, y)], fill=(r, g, b))

draw.ellipse((SIZE * 0.30, SIZE * 0.18, SIZE * 0.62, SIZE * 0.50), fill=(255, 220, 90))

draw.ellipse((SIZE * 0.18, SIZE * 0.48, SIZE * 0.62, SIZE * 0.78), fill=(255, 255, 255))
draw.ellipse((SIZE * 0.40, SIZE * 0.40, SIZE * 0.88, SIZE * 0.78), fill=(255, 255, 255))
draw.ellipse((SIZE * 0.55, SIZE * 0.52, SIZE * 0.92, SIZE * 0.82), fill=(240, 245, 250))

out_path = "/data/Aeris/Aeris/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png"
img.save(out_path, "PNG")
print("saved", out_path)
