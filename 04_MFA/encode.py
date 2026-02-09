
import base64
import os

# Získání cesty k aktuálnímu adresáři
current_dir = os.path.dirname(os.path.abspath(__file__))

# Název vstupního obrázku
input_image = "C:\\Users\\MJurca.SWSI\\Documents\\GitHub\\intranet\\04_MFA\\images\\8.png"  # změňte název podle vašeho obrázku

# Získání cesty k adresáři, kde je vstupní obrázek
image_dir = os.path.dirname(os.path.abspath(input_image))
if not image_dir:  # pokud je obrázek v aktuálním adresáři
    image_dir = os.getcwd()

# Název výstupního souboru bude stejný jako vstupní, jen s příponou _base64.txt
output_file = os.path.splitext(os.path.basename(input_image))[0] + "_base64.txt"

# Sestavení úplných cest
image_path = os.path.join(image_dir, input_image)
output_path = os.path.join(image_dir, output_file)

# Převod obrázku do base64
try:
    with open(image_path, "rb") as image_file:
        # Přečtení a zakódování obrázku
        encoded_string = base64.b64encode(image_file.read())

        # Přidání prefixu pro použití v HTML
        base64_string = f"data:image/{input_image.split('.')[-1]};base64,{encoded_string.decode('utf-8')}"

        # Uložení do souboru
        with open(output_path, "w") as text_file:
            text_file.write(base64_string)

        print(f"Base64 řetězec byl úspěšně uložen do souboru: {output_path}")

except FileNotFoundError:
    print(f"Chyba: Soubor {input_image} nebyl nalezen.")
except Exception as e:
    print(f"Nastala chyba: {str(e)}")