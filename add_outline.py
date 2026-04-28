import os
from PIL import Image, ImageFilter

def process_image(img_path):
    print("Processing", img_path)
    img = Image.open(img_path).convert("RGBA")
    
    # Resize first
    img = img.resize((256, 256), Image.Resampling.LANCZOS)
    
    r, g, b, a = img.split()
    
    # Hard threshold alpha
    a_hard = a.point(lambda p: 255 if p > 128 else 0)
    
    # Dilate alpha (3 iterations for a solid outline)
    a_dilated = a_hard.filter(ImageFilter.MaxFilter(5))
    a_dilated = a_dilated.filter(ImageFilter.MaxFilter(3))
    a_dilated = a_dilated.filter(ImageFilter.MaxFilter(3))
    
    # Smooth the outline slightly
    a_dilated = a_dilated.filter(ImageFilter.GaussianBlur(1))
    a_dilated = a_dilated.point(lambda p: 255 if p > 128 else 0)
    
    # Create solid black image
    outline = Image.new("RGBA", img.size, (0, 0, 0, 255))
    outline.putalpha(a_dilated)
    
    # Paste original on top
    outline.paste(img, (0, 0), img)
    
    outline.save(img_path, "PNG")

icons_dir = r"c:\Codigos\Tragamonedas\assets\icons"
for f in os.listdir(icons_dir):
    if f.endswith(".png"):
        process_image(os.path.join(icons_dir, f))
