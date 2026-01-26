import os

path_data=os.path.join(os.getcwd())
path_data=path_data[0:path_data.find('Proyecto_Ctes_CAPS')]+'Proyecto_CTES_Caps\datos'
path_file=lambda x:os.path.join(path_data,x)