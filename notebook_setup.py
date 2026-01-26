import sys
from pathlib import Path

# Detecta automáticamente la raíz del proyecto
current = Path.cwd()

for parent in current.parents:
    if parent.name == "Proyecto_Ctes_CAPS":
        sys.path.insert(0, str(parent))
        break
else:
    raise RuntimeError("No se encontró la raíz del proyecto Proyecto_Ctes_CAPS")
