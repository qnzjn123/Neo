from PIL import Image, ImageDraw, ImageFont
import os

def create_gradient(width, height, color1, color2):
    """Create a gradient image"""
    base = Image.new('RGB', (width, height), color1)
    top = Image.new('RGB', (width, height), color2)
    mask = Image.new('L', (width, height))
    mask_data = []
    for y in range(height):
        for x in range(width):
            mask_data.append(int(255 * (y / height)))
    mask.putdata(mask_data)
    base.paste(top, (0, 0), mask)
    return base

def create_app_icon():
    """Create the app icon"""
    size = 1024
    img = create_gradient(size, size, (108, 99, 255), (156, 99, 255))  # Purple gradient
    draw = ImageDraw.Draw(img)

    # Draw microphone shape
    mic_color = (255, 255, 255)
    center_x, center_y = size // 2, size // 2

    # Microphone capsule (ellipse)
    mic_width = size // 5
    mic_height = size // 3
    draw.ellipse(
        [(center_x - mic_width//2, center_y - mic_height//2 - size//10),
         (center_x + mic_width//2, center_y + mic_height//2 - size//10)],
        fill=mic_color
    )

    # Microphone stand arc
    draw.arc(
        [(center_x - mic_width//2 - 20, center_y),
         (center_x + mic_width//2 + 20, center_y + mic_height//2 + 40)],
        start=0, end=180, fill=mic_color, width=20
    )

    # Microphone stand line
    draw.line(
        [(center_x, center_y + mic_height//2 + 20),
         (center_x, center_y + mic_height//2 + 100)],
        fill=mic_color, width=20
    )

    # Base line
    draw.line(
        [(center_x - 80, center_y + mic_height//2 + 100),
         (center_x + 80, center_y + mic_height//2 + 100)],
        fill=mic_color, width=20
    )

    # Create directory if it doesn't exist
    os.makedirs('assets/images', exist_ok=True)

    # Save icon
    img.save('assets/images/app_icon.png')
    print('✓ App icon created: assets/images/app_icon.png')

    # Create foreground (for adaptive icon)
    img_fg = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw_fg = ImageDraw.Draw(img_fg)

    # Draw microphone on transparent background
    draw_fg.ellipse(
        [(center_x - mic_width//2, center_y - mic_height//2 - size//10),
         (center_x + mic_width//2, center_y + mic_height//2 - size//10)],
        fill=mic_color
    )
    draw_fg.arc(
        [(center_x - mic_width//2 - 20, center_y),
         (center_x + mic_width//2 + 20, center_y + mic_height//2 + 40)],
        start=0, end=180, fill=mic_color, width=20
    )
    draw_fg.line(
        [(center_x, center_y + mic_height//2 + 20),
         (center_x, center_y + mic_height//2 + 100)],
        fill=mic_color, width=20
    )
    draw_fg.line(
        [(center_x - 80, center_y + mic_height//2 + 100),
         (center_x + 80, center_y + mic_height//2 + 100)],
        fill=mic_color, width=20
    )

    img_fg.save('assets/images/app_icon_foreground.png')
    print('✓ App icon foreground created: assets/images/app_icon_foreground.png')

def create_splash_icon():
    """Create the splash screen icon"""
    size = 1024
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Draw glowing circle
    center_x, center_y = size // 2, size // 2
    radius = size // 3

    # Gradient circle
    for i in range(radius, 0, -10):
        alpha = int(255 * (i / radius))
        color = (108, 99, 255, alpha)
        draw.ellipse(
            [(center_x - i, center_y - i),
             (center_x + i, center_y + i)],
            fill=color
        )

    # Draw "NEO" text
    try:
        font = ImageFont.truetype("arial.ttf", 180)
    except:
        font = ImageFont.load_default()

    text = "NEO"
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]

    draw.text(
        (center_x - text_width//2, center_y - text_height//2),
        text,
        fill=(255, 255, 255, 255),
        font=font
    )

    img.save('assets/images/splash_icon.png')
    print('✓ Splash icon created: assets/images/splash_icon.png')

if __name__ == '__main__':
    print('🎨 Generating icons for 니오 app...')
    create_app_icon()
    create_splash_icon()
    print('✅ All icons generated successfully!')
