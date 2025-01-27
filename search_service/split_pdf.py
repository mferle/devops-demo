from PyPDF2 import PdfReader, PdfWriter
import os

def split_pdf(input_file, output_folder):
    """
    Splits a multi-page PDF into single-page PDFs.

    :param input_file: Path to the input PDF file.
    :param output_folder: Folder where the single-page PDFs will be saved.
    """
    # Check if the output folder exists, if not, create it
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # Read the input PDF
    reader = PdfReader(input_file)

    # Get the base name of the input file (without extension)
    base_name = os.path.splitext(os.path.basename(input_file))[0]

    # Loop through all the pages in the PDF
    for i, page in enumerate(reader.pages):
        # Create a new PDF writer for each page
        writer = PdfWriter()
        writer.add_page(page)

        # Save the single-page PDF to the output folder
        output_file = os.path.join(output_folder, f"{base_name}_{i+1}.pdf")
        with open(output_file, "wb") as output_pdf:
            writer.write(output_pdf)

        print(f"Saved: {output_file}")

# Example usage
if __name__ == "__main__":
    input_pdf_path = "...\\microwave.pdf"  # Replace with the path to your PDF
    output_directory = "...\\appliances"  # Replace with the desired output folder
    split_pdf(input_pdf_path, output_directory)
