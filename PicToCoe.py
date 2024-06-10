from PIL import Image
import numpy as np

def resize_image(input_image_path, output_image_path, size=(640, 480)):

    img = Image.open(input_image_path)
    
    img_resized = img.resize(size, Image.LANCZOS)
    
    img_resized.save(output_image_path)
    
    print(f"Image has been resized and saved to {output_image_path}")
    return img_resized

def image_to_coe(image, coe_path):
    img = image.convert('RGB')
    
    width, height = img.size
    
    pixel_data = np.array(img)
    
    coe_content = "memory_initialization_radix=16;\nmemory_initialization_vector=\n"
    
    for y in range(height):
        for x in range(width):
            r, g, b = pixel_data[y, x]
            hex_pixel = f"{r:02X}{g:02X}{b:02X}"
            coe_content += hex_pixel + ",\n"
    
    coe_content = coe_content.rstrip(",\n") + ";"
    
    with open(coe_path, 'w') as coe_file:
        coe_file.write(coe_content)
    
    print(f"COE file has been saved to {coe_path}")

input_image_path = '111.jpg'
resized_image_path = 'resized_example.jpg'
coe_path = 'output.coe'

# Step 1: Resize the image
resized_image = resize_image(input_image_path, resized_image_path)

# Step 2: Convert the resized image to COE file
image_to_coe(resized_image, coe_path)
