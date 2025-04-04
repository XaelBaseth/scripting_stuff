import os

# Variables
lib_name = ""
lib_name_caps = ""
cc_compiler = ""
cflags_options = ""
mand_functions = []
bonus_functions = []

# Lire le modèle de Makefile
with open("Makefile.tmp", "r") as template_file:
    template = template_file.read()

# Remplacer les variables
makefile_content = template.replace("$(LIB_NAME)", lib_name) \
                            .replace("$(LIB_NAME_CAPS)", lib_name_caps) \
                            .replace("$(CC_COMPILER)", cc_compiler) \
                            .replace("$(CFLAGS_OPTIONS)", cflags_options) \
                            .replace("$(MAND_FUNCTIONS)", " ".join(mand_functions)) \
                            .replace("$(BONUS_FUNCTIONS)", " ".join(bonus_functions))

# Écrire le Makefile généré
with open("Makefile", "w") as makefile:
    makefile.write(makefile_content)

print("Makefile generated successfully.")
