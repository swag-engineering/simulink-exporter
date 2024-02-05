import enum
import io
import logging
import os
import re


current_path = os.path.dirname(os.path.realpath(__file__))


class FixedStepSolver(str, enum.Enum):
    ODE1 = "ode1"
    ODE2 = "ode2"
    ODE3 = "ode3"
    ODE4 = "ode4"
    ODE5 = "ode5"
    ODE8 = "ode8"
    ODE14X = "ode14x"
    ODE1BE = "ode1be"


def export_model(slx_path: str, output_dir: str, step_size: float, solver: FixedStepSolver):
    import matlab.engine

    engine = None
    stdout_buffer = io.StringIO()
    stderr_buffer = io.StringIO()
    try:
        engine = matlab.engine.start_matlab(option="-nodesktop -nodisplay")
        engine.addpath(os.path.join(current_path, 'scripts'))
        if engine.is_incompatible(slx_path, nargout=1):
            raise ValueError(
                f"Model version was created with newer Matlab Release. " +
                f"It should be compatible with '{engine.get_current_release(nargout=1)}'."
            )
        engine.codegen(slx_path, output_dir, step_size, solver.value, nargout=0, stdout=stdout_buffer, stderr=stderr_buffer)
    except ValueError:
        raise
    except:
        error_stack = stderr_buffer.getvalue()
        logging.error(stdout_buffer.getvalue() + error_stack)
        cause_block = extract_cause_block(error_stack)
        if not cause_block:
            cause_block = extract_error_in_block(error_stack)
        raise ValueError(cause_block) if cause_block else ValueError("Can't build the model")
    finally:
        if engine:
            engine.quit()


def extract_cause_block(stack: str) -> str | None:
    result = re.search(r"Caused by:\n\s+.*(\n(?!\s*$).*)+", stack)
    return result.group(0) if result else None


def extract_error_in_block(stack: str) -> str | None:
    result = re.search(r"Error in '.*?': (.*?)(?=\n|$)", stack)
    return result.group(0) if result else None
