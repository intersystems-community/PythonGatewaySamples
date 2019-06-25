# PythonGateway Samples

Examples of [PythonGateway](https://github.com/intersystems-community/PythonGateway) Usage. Python Gateway for InterSystems Data Platforms. Execute Python code and more from InterSystems IRIS brings you the power of Python right into your InterSystems IRIS environment:

- Execute arbitrary Python code
- Seamlessly transfer data from InterSystems IRIS into Python
- Build intelligent Interoperability business processes with Python Interoperability Adapter
- Save, examine, modify and restore Python context from InterSystems IRIS

# Installation

1. Install [PythonGateway](https://github.com/intersystems-community/PythonGateway).
2. Load ObjectScript code (i.e. `do $system.OBJ.ImportDir("C:\InterSystems\Repos\PythongatewaySamples\","*.cls,*.xml","c",,1)`) into Production (Ensemble-enabled) namespace. In case you want to Production-enable namespace call: `write ##class(%EnsembleMgr).EnableNamespace($Namespace, 1)`.
3. Load restraunt data with: `do ##class(ml.match.Restaurant).Import()`.
4. Install these libraries:

```
pip install recordlinkage
pip install dedupe
pip install pandas
pip install numpy
pip install matplotlib
pip install sklearn
pip install seaborn
```
5. Open and start `ml.Production`.

# Samples

To choose specific example filter by production category.

## Sample 1. Data deduplication.

Using [Dedupe](https://docs.dedupe.io/en/latest/) or [RLTK](https://rltk.readthedocs.io/en/latest/) to deduplicate restraunt data.

## Sample 2. ML Robotization / Engines

We start with working self-correcting model used for predictive maintenance. First, we see how production elements work together and how our transactional processes can benefit from AI/ML models. After that we’d improve the model and see how this change propagates through production. Finally, we’ll explore different applications of this architecture. 

 ### Walkthrough 

We want to do predictive maintenance on engines. Dataset: we store information about one specific engine. We get a large array of sensor data every second. Historic data is already in the dataset. 

### Production

- Python Operation: operation to execute Python code
- Train process: trains new model
- Predict Process: predicts maintenance value and returns it using model from `Train Process`
- Init Service: trais initial model via `Train process`
- Predict Service: once a second the service sends information about engine to `Predict Process`
- Check Service: checks quality of the model latest predictions

Start `Predict Service` and `Check Service` to see model be automatically retrained when prediction quality drops.

 ### Predict Process walkthrough 
        
- Import – load Python libraries
- Load Data – load data for model trainig
- Extract Y – separate data into X (sensor data) and Y (engine state)
- PCA – principal components calculation
- CV – potential models cross-validation
- Fit – creating a pipeline



