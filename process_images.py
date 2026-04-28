import os
from PIL import Image

def remove_white_bg(img_path, out_path):
    img = Image.open(img_path).convert("RGBA")
    datas = img.getdata()
    
    newData = []
    for item in datas:
        if item[0] > 240 and item[1] > 240 and item[2] > 240:
            newData.append((255, 255, 255, 0))
        else:
            newData.append(item)
            
    img.putdata(newData)
    
    bbox = img.getbbox()
    if bbox:
        img = img.crop(bbox)
        
    img.save(out_path, "PNG")

os.makedirs(r"c:\Codigos\Tragamonedas\assets\icons", exist_ok=True)

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

for name, filename in images.items():
    in_path = os.path.join(brain_dir, filename)
    out_path = os.path.join(r"c:\Codigos\Tragamonedas\assets\icons", f"{name}.png")
    if os.path.exists(in_path):
        remove_white_bg(in_path, out_path)
        print(f"Processed {name}")
    else:
        print(f"File not found: {in_path}")
