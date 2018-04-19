# Modified script for fitting one density map into another.
# Original fitnogui.py script from
# http://plato.cgl.ucsf.edu/trac/chimera/attachment/wiki/Scripts/fitnogui.py
# 

import argparse
from VolumeViewer import open_volume_file
from FitMap.fitmap import map_points_and_weights, motion_to_maximum
import Matrix

parser = argparse.ArgumentParser(
    description='Fits one electron density map into another.')

parser.add_argument('--map1', type=str, required=True,
                    help='Path to the first volume file.')
parser.add_argument('--map2', type=str, required=True,
                    help='Path to the second volume file.')
args = parser.parse_args()
    
def fit_map_in_map(map1_path, map2_path,
                   initial_map1_transform = None,
                   map1_threshold = None,
                   ijk_step_size_min = 0.01,    # Grid index units
                   ijk_step_size_max = 0.5,     # Grid index units
                   max_steps = 2000,
                   optimize_translation = True,
                   optimize_rotation = True,
                   metric='sum product'): # 'sum product' > overlap; other options are 'correlation' and 'correlation about mean'
	
	
    # Files have to have file suffix indicating volume format.
    map1 = open_volume_file(map1_path)[0]  # Assume files contain just one array
    map2 = open_volume_file(map2_path)[0]
	
    if initial_map1_transform:
        from Matrix import chimera_xform
	xf = chimera_xform(initial_map1_transform)
	map1.surface_model().openState.globalXform(xf)
	   
    use_threshold = (map1_threshold != None)	 
    points, point_weights = map_points_and_weights(map1, use_threshold)
	
    if len(points) == 0:
         if use_threshold:
             print 'No grid points above map threshold.'
         else:
	     print 'Map has no non-zero values.'
	 return
	
    move_tf, stats = motion_to_maximum(points, point_weights, map2,
                                       max_steps, ijk_step_size_min,
                                       ijk_step_size_max,
                                       optimize_translation,
                                       optimize_rotation, metric)
                                                     	
     
    if initial_map1_transform:
        move_tf = Matrix.multiply_matrices(move_tf,
                                           initial_map1_transform)
	
    header = ('\nFit map %s in map %s using %d points\n'
	      % (map1.name, map2.name, stats['points']) +
	      '  correlation = %.4g, overlap = %.4g\n'
	      % (stats['correlation'], stats['overlap']) +
	      '  steps = %d, shift = %.3g, angle = %.3g degrees\n'
	      % (stats['steps'], stats['shift'], stats['angle']))
    print header
	
    tfs = Matrix.transformation_description(move_tf)
    print tfs
    
if __name__ == '__main__':
    fit_map_in_map(args.map1, args.map2)

