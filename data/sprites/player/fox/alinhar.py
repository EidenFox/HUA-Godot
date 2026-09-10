import os
from PIL import Image

# INICIO DE FUNÇÃO DE [align_images_to_bottom]; esta função faz [a leitura de todos os arquivos .png do diretório atual (ignorando .import), identifica os limites visíveis e desloca os pixels não transparentes para a base, salvando na pasta "out" sem alterar a resolução]
def align_images_to_bottom(input_dir, output_dir):
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    for filename in os.listdir(input_dir):
        if filename.lower().endswith('.png'): 
            input_path = os.path.join(input_dir, filename)
            output_path = os.path.join(output_dir, filename)

            try:
                img = Image.open(input_path).convert("RGBA")
                
                bbox = img.getbbox()

                if bbox:
                    left, upper, right, lower = bbox
                    shift_y = img.height - lower

                    if shift_y > 0:
                        aligned_img = Image.new("RGBA", img.size, (0, 0, 0, 0))
                        content = img.crop(bbox)
                        
                        aligned_img.paste(content, (left, upper + shift_y))
                        aligned_img.save(output_path)
                    else:
                        img.save(output_path)
                else:
                    pass

            except Exception as e:
                print(f"Error {filename}: {e}")

# Execução
if __name__ == "__main__":
    input_dir = "."
    output_dir = "out"
    align_images_to_bottom(input_dir, output_dir)