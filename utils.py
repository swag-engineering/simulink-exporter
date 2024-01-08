import os

import matlab.engine

current_path = os.path.dirname(os.path.realpath(__file__))


def export_model(slx_path: str, output_dir: str, step_size: float):
    engine = None
    try:
        engine = matlab.engine.start_matlab(option="-nodesktop -nodisplay")
        engine.addpath(os.path.join(current_path, 'scripts'))
        engine.codegen(slx_path, output_dir, step_size, nargout=0)
    finally:
        if engine:
            engine.quit()


