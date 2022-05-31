
## SPM pipeline for learning tasks
![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)

This repository was **initially created on 18-05-2022** for an internship in the [Section of Cognitive Psychology](https://www.psychologie.uni-bonn.de/de-en/about-us/sections/cognitive-psychology?set_language=en) at the Department of Psychology at the University of Bonn from 15-03-2022 to 15-06-2022.

It contains scripts for analysis of behavioral and hemodynamic data of subjects[^2] who performed a **Procedural Learning**[^1] task 
and an **Object Location Association**[^3] task.

### Citation
If you use this code or parts of it, please cite:

Vorreuther, A. (2022). *A custom analysis pipeline for fMRI data using the Statistical Parametric Mapping software*. Retrieved from https://github.com/acv132/SPM_pipeline_learning_tasks.
```
@unpublished{vorreuther2022,
title = {A custom analysis pipeline for fMRI data using the Statistical Parametric Mapping software},
author = {{Vorreuther, Anna}},
year = {2022},
note = {unpublished}
}
```


### Requirements
- [IBM SPSS 25](https://www.ibm.com/support/pages/downloading-ibm-spss-statistics-25)
- [SPM 12](https://github.com/acv132/spm12)
- [marsbar 0.45](https://github.com/acv132/marsbar)
- [WFU PickAtlas 3.0.5b](https://www.nitrc.org/projects/wfu_pickatlas/)

### Setup

Make sure that all required toolboxes and software are installed and running. For help, refer to the respective website and documentation (see also links above).

#### Recommended folder setup
When downloading the code, it is recommended to move the folder containing the data of subjects (not available here) adjacent to the 2022_analysis_script folder:
```bash
├───2022_analysis_script
│   ├───behavioral
│   │   ├───OLA
│   │   └───PL
│   ├───data
│   │   └───ROIs
│   │       ├───OLA
│   │       └───PL
│   ├───fmri
│   │   ├───OLA
│   │   ├───PL
│   │   └───preprocessing
│   ├───results
│   │   ├───behavioral
│   │	└───[batch file to fmri results folder]
│   └───utils
│       └───...
└───DATA
    ├───Additional Logfiles
    ├───Behavioral
    ├───Subjects
    └───results
```
The `DATA` folder should contain all additional logfiles, behavioral and subject fmri data. A `results` folder will be generated here for the fmri results by the analysis script.

#### References
[^1]: [Ettinger, U., Corr, P. J., Mofidi, A., Williams, S. C., & Kumari, V. (2013). Dopaminergic basis of the psychosis-prone personality investigated with functional magnetic  resonance imaging of procedural learning. Frontiers in human neuroscience, 7, 130.](https://www.frontiersin.org/articles/10.3389/fnhum.2013.00130/full)
[^2]: [Kasparbauer, A. M., Meyhöfer, I., Steffens, M., Weber, B., Aydin, M., Kumari, V., ... & Ettinger, U. (2016). Neural effects of methylphenidate and nicotine during smooth pursuit eye movements. Neuroimage, 141, 52-59.](https://www.sciencedirect.com/science/article/abs/pii/S1053811916303196)
[^3]: [Kukolja, J., Thiel, C. M., Wilms, M., Mirzazade, S., & Fink, G. R. (2009). Ageing-related changes of neural activity associated with spatial contextual memory.     Neurobiology of aging, 30(4), 630-645.](https://www.sciencedirect.com/science/article/abs/pii/S0197458007003363)
