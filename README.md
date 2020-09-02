# PythonGateway Samples

Examples of [PythonGateway](https://github.com/intersystems-community/PythonGateway) Usage. Python Gateway for InterSystems Data Platforms. Execute Python code and more from InterSystems IRIS brings you the power of Python right into your InterSystems IRIS environment:

- Execute arbitrary Python code
- Seamlessly transfer data from InterSystems IRIS into Python
- Build intelligent Interoperability business processes with Python Interoperability Adapter
- Save, examine, modify and restore Python context from InterSystems IRIS

# Docker Installation

1. Download the repo:
```
git clone https://github.com/intersystems-community/PythonGatewaySamples.git
cd PythonGatewaySamples
```
2. Get the images: `docker-compose build --pull`
3. Start docker: `docker-compose up -d`

# Host Installation

1. Install [PythonGateway](https://github.com/intersystems-community/PythonGateway).
2. Load ObjectScript code (i.e. `do $system.OBJ.ImportDir("C:\InterSystems\Repos\PythongatewaySamples\","*.cls","c",,1)`) into Production (Ensemble-enabled) namespace. In case you want to Production-enable namespace call: `write ##class(%EnsembleMgr).EnableNamespace($Namespace, 1)`.
3. Load restaurant data with: `do ##class(ml.match.Restaurant).Import()`.
4. Load match data with: `do $system.OBJ.ImportDir("C:\InterSystems\Repos\PythongatewaySamples\","*.xml","c")`
5. Install required libraries: `pip install -r requirements.txt`
6. Open and start `ml.Production`.

# Samples

To choose a specific example filter by production category.

## Sample 1. Data deduplication.

Using [Dedupe](https://docs.dedupe.io/en/latest/) or [RLTK](https://rltk.readthedocs.io/en/latest/) to deduplicate restaurant data.

## Sample 2. ML Robotization / Engines

We start with the working self-correcting model used for predictive maintenance. First, we see how production elements work together and how our transactional processes can benefit from AI/ML models. After that, we’d improve the model and see how this change propagates through production. Finally, we’ll explore different applications of this architecture. 

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

This example shows an image similarity search, by default we are using the footwear dataset, but any type of image can be used, as long as the target object is the main object on the images in the dataset. Additionally, this example shows how an AI model can be exposed via REST API in InterSystems IRIS. This example can be used as a feature in retail a mobile app to allow users to take product photos from a camera and find the corresponding product(s) from the retailer shop.

### Docker setup

1. Execute steps 1 and 2 from `Docker Installation` above. Do not run the containers.
2. To preserve the index mount volume to the `/usr/irissys/mgr/Temp` directory. `docker-compose.yml` contains an example. Uncomment the lines and point docker to the empty host directory. If you're running DD on Windows with HV backend you'll additionally need to share the host directory with Docker.
3. Start docker: `docker-compose up -d`
4. (OPTIONAL BUT RECOMMENDED) To use the prebuilt index download the [index file](https://www.dropbox.com/s/x94x5dshttofdf1/index.zip?dl=1) and corresponding globals [here](https://gist.githubusercontent.com/eduard93/7fde198dc712cfff81834b6cd66c3992/raw/85a30685b0deff73a74332907d52cfb5915ed388/context.xml). Unpack the index into the root of the mounted directory. Import globals into the PYTHON namespace.
5. Enable `ml.cam.ens.bs.InitService`
6. Open `http://localhost:52773/csp/user/recommend.html` and upload your image (you can use images from `img` directory for testing)


### Walkthrough

- `ml.cam.data.Photo` class contains our dataset of photos. Use `LoadDir` method to add more photos.
- `ml.cam.ens.bp.LoaderProcess` receives ids of `ml.cam.data.Photo` and indexes them:
  - Images are resized and rescaled
  - Images are passed to the chosen NN to get feature vectors (note that we use NN without the last classification layer to get better results for an image as a whole)
  - Feature Vectors are indexed using cosine index
  - The index is saved (mmaped) on disk for later reuse
  - Corresponding variables are saved as an `isc.py.data.Context` to Intersystems IRIS
- On subsequent runs `ml.cam.ens.bp.LoaderProcess` first checks if saved context exists and if it does loads the index/variables instead of building it again
- `ml.cam.ens.bs.InitService` sends initial trainig request on production startup
- `ml.cam.ens.bp.MatcherProcess` receives one target image and uses the index to find the best matches
- `cam.rest.Main` exposes `ml.cam.ens.bp.MatcherProcess` as a REST API web application `/cam`
- `recommend.html` calls `/cam` to get the best matches for an uploaded image (you can use images from `img` directory for testing)


### Host setup

Execute all steps from `Host Installation` first.

1. Download and unpack any image dataset, for example, [this](http://vision.cs.utexas.edu/projects/finegrained/utzap50k/ut-zap50k-images.zip).
2. Load dataset into InterSystems IRIS: `zw ##class(ml.cam.data.Photo).LoadDir(<dir>)`.
3. Enable `ml.cam.ens.bs.InitService`.
4. Training will take 1-5 hours depending on your CPU/GPU.
5. The training process saves the search index automatically so subsequent runs will take <1 minute.
6. Copy `recommend.html` to any web application.
7. Create new unauthenticated REST app named `/cam` with `ml.cam.rest.Main` dispatch class.
8. Open `recommend.html` in a browser and send your test image


### Notes

- To train a new index (after you already have one) execute:

```SQL
TRUNCATE TABLE isc_py_data.Context
TRUNCATE TABLE isc_py_data.Variable
```

- Sometimes after training the index might perform poorly. In that case, restart the production.
- Prebuilt index is available [here](https://www.dropbox.com/s/x94x5dshttofdf1/index.zip?dl=1), corresponding globals [here](https://gist.githubusercontent.com/eduard93/7fde198dc712cfff81834b6cd66c3992/raw/85a30685b0deff73a74332907d52cfb5915ed388/context.xml). Save index as `/usr/irissys/mgr/Temp/index.ann`  (this is Default for Docker, in general use check `WorkDirectory` value for `ml.cam.ens.bp.LoaderProcess` and save the file there as `index.ann`).


