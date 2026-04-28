import os
from PIL import Image, ImageFilter

brain_dir = r"C:\Users\Usuario\.gemini\antigravity\brain\60f509b7-a33c-4f42-b228-19c5ba471927"
images = {
    "apple": "icon_apple_1777402937760.png",
    "cherry": "icon_cherry_1777403020213.png",
    "orange": "icon_orange_1777403035634.png",
    "plum": "icon_plum_1777403048966.png",
    "watermelon": "icon_watermelon_1777403059737.png",
    "bell": "icon_bell_1777403071890.png",
    "star": "icon_star_1777403138258.png",
    "seven": "icon_seven_1777403092953.png",
    "bar": "icon_bar_1777403105956.png",
    "lemon": "icon_lemon_1777403118802.png",
}

def remove_white_bg_and_outline(img_path, out_path):
    img = Image.open(img_path).convert("RGBA")
    datas = img.getdata()
    
    # Remove white background
    newData = []
    for item in datas:
        if item[0] > 240 and item[1] > 240 and item[2] > 240:
            newData.append((255, 255, 255, 0))
        else:
            newData.append(item)
    img.putdata(newData)
    
    # Crop to bounding box
    bbox = img.getbbox()
    if bbox:
        img = img.crop(bbox)
        
    # Shrink so outline fits
    img.thumbnail((200, 200), Image.Resampling.LANCZOS)
    
    # Create a 256x256 transparent canvas
    canvas = Image.new("RGBA", (256, 256), (0, 0, 0, 0))
    offset = ((256 - img.width) // 2, (256 - img.height) // 2)
    canvas.paste(img, offset, img)
    
    # Now create outline
    r, g, b, a = canvas.split()
    
    a_hard = a.point(lambda p: 255 if p > 60 else 0)
    
    a_dilated = a_hard.filter(ImageFilter.MaxFilter(7))
    a_dilated = a_dilated.filter(ImageFilter.MaxFilter(5))
    
    a_dilated = a_dilated.filter(ImageFilter.GaussianBlur(1))
    a_dilated = a_dilated.point(lambda p: 255 if p > 128 else 0)
    
    outline = Image.new("RGBA", canvas.size, (0, 0, 0, 255))
    outline.putalpha(a_dilated)
    
    outline.paste(canvas, (0, 0), canvas)
    outline.save(out_path, "PNG")

for name, filename in images.items():
    in_path = os.path.join(brain_dir, filename)
    out_path = os.path.join(r"c:\Codigos\Tragamonedas\assets\icons", f"{name}.png")
    if os.path.exists(in_path):
        remove_white_bg_and_outline(in_path, out_path)
        print(f"Processed {name}")
    else:
        print(f"File not found: {in_path}")
