# (C) All rights reserved. ECOLE POLYTECHNIQUE FEDERALE DE LAUSANNE,
# Switzerland, Laboratory of Experimental Biophysics, 2018

"""Translates and/or rotates a model relative to another in Chimera.

Based on the transform_cb method from MoleculeTransform/gui.py in
Chimera.

Kyle M. Douglass, 2018

"""

import argparse
from VolumeViewer import open_volume_file
import MoleculeTransform as mt
from chimera import Molecule

parser = argparse.ArgumentParser(
    description='Translates and/or rotates a model relative to '
                'another.')

parser.add_argument('--model_path', type=str, required=True,
                    help='Path to the model file that will be moved.')
parser.add_argument('--fixed_model_path', type=str, required=True,
                    help='Path to the model file that remains fixed.')
parser.add_argument('--x', type=float, required=True,
                    help='x-displacement')
parser.add_argument('--y', type=float, required=True,
                    help='y-displacement')
parser.add_argument('--z', type=float, required=True,
                    help='z-displacement')

args = parser.parse_args()

def transform(model_path, fixed_model_path, ea = (0.0, 0.0, 0.0),
              t = (0.0, 0.0, 0.0), move_atoms=True):
    """Translates and/or rotates a model.

    Parameters
    ----------
    model_path : str
        The path to the file containing the model that will be moved.
    fixed_model_path : str
        The path to the file containing the model that will remain
        in place.
    ea : tuple
        3-tuple of Euler angles for rotating the model.
    t : tuple
        3-tuple of xyz displacements for translating the model.
    move_atoms : bool
        Determines whether the atoms or the coordinate system should
        be moved.

    """
    model = open_volume_file(model_path)[0]
    fixed_model = open_volume_file(fixed_model_path)[0]
    
    try:
      ea = map(float, ea)
      t = map(float, t)
    except ValueError:
      from chimera.replyobj import warning
      warning('Error parsing Euler angle or translation number')
      return

    if len(ea) != 3:
      from chimera.replyobj import warning
      warning('Requires 3 Euler angles.')
      return

    if len(t) != 3:
      from chimera.replyobj import warning
      warning('Requires 3 translation values.')
      return

    xf = mt.euler_xform(ea, t)
    if isinstance(model, Molecule) and move_atoms:
      mt.transform_atom_coordinates(m.atoms, xf)
    else:
      mt.transform_coordinate_axes(model, xf)

    print('Transformation matrix:')
    print(xf)


if __name__ == '__main__':
    #model_path = '/home/laboleb/ScipionUserData/projects/2017-12-01_Cep152_Cep164/Runs/000557_XmippProtProjMatch/extra/iter_001/reconstruction_split_1_Ref3D_001.vol'
    #fixed_model_path = '/home/laboleb/ScipionUserData/projects/2017-12-01_Cep152_Cep164/Runs/000713_EmanProtReconstruct/extra/volume.hdf'
    #transform(model_path, fixed_model_path, t=(5, 5, 5))
    transform(args.model_path, args.fixed_model_path,
              t=(args.x, args.y, args.z))
