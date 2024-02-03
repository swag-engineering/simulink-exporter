# Simulink Exporter

This project is a component of the [Simbind](https://github.com/swag-engineering/simbind-cli) tool and includes a
primary function:

```python
# simulink_exporter/utils.py

def export_model(
        slx_path: str,
        output_dir: str,
        step_size: float,
        solver: FixedStepSolver
):
    ...
```

The _export_model_ function leverages [matlabengine](https://pypi.org/project/matlabengine/) to build a specified _.slx_
model using a defined _solver_ and _fixed time step_. It then outputs _.c_ and _.h_ files to the specified directory.

## Requirements

The only dependency you will see in _requirements.txt_ is _matlabengine_, but be aware _matlabengine_ is very cranky and
will reject to be installed if you don't have Matlab installed, or if there is missmatch between _matlabengine_ version
and Matlab release, or if there is missmatch between _matlabengine_ and Python versions. With specified
_matlabengine==9.14.3_ you need:

- Matlab release R2023b or older
- Python 3.9, 3.10 or 3.11

To find _matlabengine_ version that fits you need you can refer
to [Release history](https://pypi.org/project/matlabengine/9.14.3/#history).