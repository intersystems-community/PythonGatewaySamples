# PythonGateway Samples

Examples of [PythonGateway](https://github.com/intersystems-community/PythonGateway) Usage. Python Gateway for InterSystems Data Platforms. Execute Python code and more from InterSystems IRIS brings you the power of Python right into your InterSystems IRIS environment:

- Execute arbitrary Python code
- Seamlessly transfer data from InterSystems IRIS into Python
- Build intelligent Interoperability business processes with Python Interoperability Adapter
- Save, examine, modify and restore Python context from InterSystems IRIS

# Installation

1. Install [PythonGateway](https://github.com/intersystems-community/PythonGateway).
2. Load ObjectScript code (i.e. `do $system.OBJ.ImportDir("C:\InterSystems\Repos\PythongatewaySamples\","*.cls","c",,1)`) into Production (Ensemble-enabled) namespace. In case you want to Production-enable namespace call: `write ##class(%EnsembleMgr).EnableNamespace($Namespace, 1)`.
3. Load restaurant data with: `do ##class(ml.match.Restaurant).Import()`.
4. Load match data with: `do $system.OBJ.ImportDir("C:\InterSystems\Repos\PythongatewaySamples\","*.xml","c")`
5. Install these libraries:

```
pip install recordlinkage
pip install dedupe
pip install pandas
pip install numpy
pip install matplotlib
pip install sklearn
pip install seaborn
pip install tensorflow
pip install tensorflow_hub
pip install annoy
```
6. Open and start `ml.Production`.

# Samples

To choose specific example filter by production category.

## Sample 1. Data deduplication.

Using [Dedupe](https://docs.dedupe.io/en/latest/) or [RLTK](https://rltk.readthedocs.io/en/latest/) to deduplicate restraunt data.

## Sample 2. ML Robotization / Engines

We start with working self-correcting model used for predictive maintenance. First, we see how production elements work together and how our transactional processes can benefit from AI/ML models. After that we’d improve the model and see how this change propagates through production. Finally, we’ll explore different applications of this architecture. 

### Walkthrough 

We want to do predictive maintenance on engines. Dataset: we store information about one specific engine. We get a large array of sensor data every second. Historic data is already in the dataset. Check [Engine.md](Engine.md) for a step-by-step walkthrough. Note that GitHub does not render base64 embedded images, so you'll need a separate markdown viewer.


### Production

- `py.ens.Operation` – executes Python code and sends back the results.
- `ml.engine.TrainProcess` – trains a new prediction model.
- `ml.engine.PredictService` – a service that receives information from engine sensors and sends it to ml.engine.PredictProcess to predict engine state. At the moment it is disabled (grey) and does not transfer data.
- `ml.engine.PredictProcess` - uses the ML model to predict engine state.
- `ml.engine.CheckService` – regularly checks the accuracy of the ML model. If the prediction error rate is above the threshold, the service sends a request to the `ml.engine.TrainProcess` to update the model.
- `ml.engine.InitService` – sends a request to the `ml.engine.TrainProcess` to train the initial model at production start.

Start `Predict Service` and `Check Service` to see model be automatically retrained when prediction quality drops.

 ### Predict Process walkthrough 
        
- Import - load Python libraries
- Load Data - load the data for model training
- Extract Y - split the data into X - the independent variables and Y - the dependent variable we are predicting
- PCA - The [principal components](https://towardsdatascience.com/a-step-by-step-explanation-of-principal-component-analysis-b836fb9c97e2) calculation for X
- CV - [cross-validation](https://machinelearningmastery.com/k-fold-cross-validation/) of potential models
- Fit - [pipeline](https://www.kaggle.com/baghern/a-deep-dive-into-sklearn-pipelines) creation and training


## Sample 3. Image Search engine

Do not forget to switch into `Cam` category.

### Host setup

1. Download and unpack any image dataset, for example [this](http://vision.cs.utexas.edu/projects/finegrained/utzap50k/ut-zap50k-images.zip).
2. Load dataset into InterSystems IRIS: `zw ##class(ml.cam.data.Photo).LoadDir(<dir>)`.
3. Restart production, it will resend initial trainig request.
4. Training will take between 10 minutes to 5 hours depending on your CPU/GPU.
5. Trainig process saves search index automatically so subsequent runs will take <1 minute.
6. Copy `recommend.html` to any web application.
7. Create new unauthenticated REST app named `/cam` with `ml.cam.rest.Main` dispatch class.
8. Open `recommend.html` in browser and send your test image

### Docker setup

To preserve index mount volume to the `/usr/irissys/mgr/Temp` directory. `docker-compose.yml` contains an example.