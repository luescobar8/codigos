source("anomaliesML.R")

#====== AN ======
#Detect
events_o <- evtdet.anomaly(test, ts.anomalies.an, k=12, alpha=3)
#Evaluate
evaluate(events_o, reference, metric="confusion_matrix")
#Plot
print(evtplot(test,events_o, reference))

#====== K-means ======
#Detect
events_o <- evtdet.anomaly(test, ts.anomalies.kmeans, alpha=3)
#Evaluate
evaluate(events_o, reference, metric="confusion_matrix")
#Plot
print(evtplot(test,events_o, reference))

#====== DBScan ======
#Detect
events_o <- evtdet.anomaly(test, ts.anomalies.dbscan)
#Evaluate
evaluate(events_o, reference, metric="confusion_matrix")
#Plot
print(evtplot(test,events_o, reference))

#====== NNET ======
#Detect
events_o <- evtdet.anomaly(test, ts.anomalies.ml, ml_model=ts_nnet, sw_size=50, input_size = 10)
#Evaluate
evaluate(events_o, reference, metric="confusion_matrix")
#Plot
print(evtplot(test,events_o, reference))

#====== SVM ======
#Detect
events_o <- evtdet.anomaly(test, ts.anomalies.ml, ml_model=ts_svm, sw_size=50, input_size = 5)
#Evaluate
evaluate(events_o, reference, metric="confusion_matrix")
#Plot
print(evtplot(test,events_o, reference))

#====== RF ======
#Detect
events_o <- evtdet.anomaly(test, ts.anomalies.ml, ml_model=ts_rf, sw_size=50, input_size = 5)
#Evaluate
evaluate(events_o, reference, metric="confusion_matrix")
#Plot
print(evtplot(test,events_o, reference))

#====== ELM ======
#Detect
events_o <- evtdet.anomaly(test, ts.anomalies.ml, ml_model=ts_elm, sw_size=50, input_size = 5)
#Evaluate
evaluate(events_o, reference, metric="confusion_matrix")
#Plot
print(evtplot(test,events_o, reference))

#====== MLP ======
#Detect
events_o <- evtdet.anomaly(test, ts.anomalies.ml, ml_model=ts_mlp, sw_size=50, input_size = 5)
#Evaluate
evaluate(events_o, reference, metric="confusion_matrix")
#Plot
print(evtplot(test,events_o, reference))

#====== tensor_cnn ======
#Detect
events_o <- evtdet.anomaly(test, ts.anomalies.ml, ml_model=ts_tensor_cnn, sw_size=50, input_size = 5)
#Evaluate
evaluate(events_o, reference, metric="confusion_matrix")
#Plot
print(evtplot(test,events_o, reference))

#====== tensor_lstm ======
#Detect
events_o <- evtdet.anomaly(test, ts.anomalies.ml, ml_model=ts_tensor_lstm, sw_size=50, input_size = 5)
#Evaluate
evaluate(events_o, reference, metric="confusion_matrix")
#Plot
print(evtplot(test,events_o, reference))

#ts_arima()
#ts_eelm_dir(4)
#ts_emlp_dir(4)


