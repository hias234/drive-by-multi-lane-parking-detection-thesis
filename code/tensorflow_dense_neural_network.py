def simple_dense_model(dataset, x_train, y_train):
    hidden_dims = 64

    # defining the deep neural network structure
    model = Sequential()
    model.add(Dense(hidden_dims, activation='relu', 
                    input_dim=len(dataset.x[0])))
    model.add(Dropout(0.2))
    model.add(Dense(hidden_dims, activation='relu'))
    model.add(Dropout(0.2))
    model.add(Dense(hidden_dims, activation='relu'))
    model.add(Dropout(0.2))
    model.add(Dense(hidden_dims, activation='relu'))
    model.add(Dropout(0.2))
    model.add(Dense(hidden_dims, activation='relu'))
    model.add(Dropout(0.2))
    model.add(Dense(len(dataset.class_labels), 
                    activation='softmax'))

    # setting optimization function and -metric
    model.compile(loss='categorical_crossentropy',
                  optimizer='adam',
                  metrics=['accuracy'])

    # training the model
    model.fit(x_train, y_train, epochs=200)
	
    return model