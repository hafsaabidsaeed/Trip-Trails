import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UploadPackageForm extends StatefulWidget {
  @override
  _UploadPackageFormState createState() => _UploadPackageFormState();
}

class _UploadPackageFormState extends State<UploadPackageForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  var image1Ctrl = TextEditingController();
  var image2Ctrl = TextEditingController();
  var image3Ctrl = TextEditingController();
  var latCtrl = TextEditingController();
  var lngCtrl = TextEditingController();
  List paths =[];
  String _helperText = 'Enter paths list to help users to go to the desired destination like : Dhaka to Sylhet by Bus - 200Tk.....';

  //travel guide

  var startpointNameCtrl = TextEditingController();
  var endpointNameCtrl = TextEditingController();
  var priceCtrl = TextEditingController();
  var startpointLatCtrl = TextEditingController();
  var startpointLngCtrl = TextEditingController();
  var endpointLatCtrl = TextEditingController();
  var endpointLngCtrl = TextEditingController();
  var pathsCtrl = TextEditingController();

  bool uploadStarted = false;

  // Method to clear the fields after form submission
  void clearFields() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _startDateController.clear();
    _endDateController.clear();
    FocusScope.of(context).unfocus();
    image1Ctrl.clear();
    image2Ctrl.clear();
    image3Ctrl.clear();
    latCtrl.clear();
    lngCtrl.clear();
    startpointNameCtrl.clear();
    endpointNameCtrl.clear();
    priceCtrl.clear();
    startpointLatCtrl.clear();
    startpointLngCtrl.clear();
    endpointLatCtrl.clear();
    endpointLngCtrl.clear();
    pathsCtrl.clear();
    paths.clear();
  }


  // Method to handle form submission
  void handleSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() => uploadStarted = true);
      // Save to database logic here
      Future.delayed(Duration(seconds: 2), () {
        setState(() => uploadStarted = false);
        clearFields();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Package uploaded successfully!'),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Text(
            'Travel Package Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          // Package Name Field
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Package Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a package name';
              }
              return null;
            },
          ),
          SizedBox(height: 16),

          // Description Field
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          SizedBox(height: 16),

          // Price Field
          TextFormField(
            controller: _priceController,
            decoration: InputDecoration(
              labelText: 'Price',
              border: OutlineInputBorder(),
              suffixText: 'PKR',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a price';
              }
              return null;
            },
          ),
          SizedBox(height: 16),

          // Start Date and End Date in the same row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _startDateController,
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2030),
                    );
                    if (pickedDate != null) {
                      _startDateController.text =
                          DateFormat('dd MMM yyyy').format(pickedDate);
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please select a start date';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _endDateController,
                  decoration: InputDecoration(
                    labelText: 'End Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2030),
                    );
                    if (pickedDate != null) {
                      _endDateController.text =
                          DateFormat('dd MMM yyyy').format(pickedDate);
                    }
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please select an end date';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                controller: latCtrl,
                decoration: InputDecoration(
                  labelText: 'Latitude',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the latitude';
                  }
                  return null;
                },
              ),
              ),

              SizedBox(width: 16),

              Expanded(
                  child:
                  // Longitude Field
                  TextFormField(
                    controller: lngCtrl,
                    decoration: InputDecoration(
                      labelText: 'Longitude',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the longitude';
                      }
                      return null;
                    },
                  ),

              ),
            ],
          ),



          SizedBox(height: 16),

          // Image URLs Field
          TextFormField(
            controller: image1Ctrl,
            decoration: InputDecoration(
              labelText: 'Image 1 URL',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter an image URL';
              }
              return null;
            },
          ),
          SizedBox(height: 16),

          TextFormField(
            controller: image2Ctrl,
            decoration: InputDecoration(
              labelText: 'Image 2 URL',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),

          TextFormField(
            controller: image3Ctrl,
            decoration: InputDecoration(
              labelText: 'Image 3 URL',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 32),

          // Submit Button
          Container(
            height: 50,
            child: ElevatedButton(
              onPressed: handleSubmit,
              child: uploadStarted
                  ? CircularProgressIndicator(
                color: Colors.white,
              )
                  : Text(
                'Upload Package',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),

          SizedBox(height: 50,),
          Text('Travel Guide Details', style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w800
          ),),
          SizedBox(height: 20,),


          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  // decoration: InputDecoration('Enter startpont name', 'Startpont name', startpointNameCtrl),
                  controller: startpointNameCtrl,

                  validator: (value){
                    if(value!.isEmpty) return 'Value is empty'; return null;
                  },

                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: TextFormField(
                  // decoration: InputDecoration('Enter endpoint name', 'Endpoint name', endpointNameCtrl),


                  controller: endpointNameCtrl,
                  validator: (value){
                    if(value!.isEmpty) return 'Value is empty'; return null;
                  },

                ),
              ),

            ],
          ),

          SizedBox(height: 20,),
          TextFormField(
            // decoration: InputDecoration('Enter travel cost', 'Price', priceCtrl),
            keyboardType: TextInputType.number,

            controller: priceCtrl,
            validator: (value){
              if(value!.isEmpty) return 'Value is empty'; return null;
            },

          ),
          SizedBox(height: 20,),

          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  // decoration: InputDecoration('Enter startpoint latitude', 'Startpoint latitude', startpointLatCtrl),
                  controller: startpointLatCtrl,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(value!.isEmpty) return 'Value is empty'; return null;
                  },

                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: TextFormField(
                  // decoration: InputDecoration('Enter startpoint longitude', 'Startpoint longitude', startpointLngCtrl),
                  keyboardType: TextInputType.number,

                  controller: startpointLngCtrl,
                  validator: (value){
                    if(value!.isEmpty) return 'Value is empty'; return null;
                  },

                ),
              ),

            ],
          ),
          SizedBox(height: 20,),

          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  // decoration: InputDecoration('Enter endpoint latitude', 'Endpoint latitude', endpointLatCtrl),
                  controller: endpointLatCtrl,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(value!.isEmpty) return 'Value is empty'; return null;
                  },

                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: TextFormField(
                  // decoration: InputDecoration('Enter endpoint longitude', 'Endpoint longitude', endpointLngCtrl),
                  keyboardType: TextInputType.number,

                  controller: endpointLngCtrl,
                  validator: (value){
                    if(value!.isEmpty) return 'Value is empty'; return null;
                  },

                ),
              ),

            ],
          ),
          SizedBox(height: 20,),

          TextFormField(

            decoration: InputDecoration(
                hintText: "Enter path list one by one by tapping 'Enter' everytime",
                border: OutlineInputBorder(),
                labelText: 'Paths list',
                helperText: _helperText,
                contentPadding: EdgeInsets.only(right: 0, left: 10, top: 15, bottom: 5),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.grey[300],
                    child: IconButton(icon: Icon(Icons.clear, size: 15, color: Colors.blueAccent,), onPressed: (){
                      pathsCtrl.clear();
                    }),
                  ),
                )

            ),
            controller: pathsCtrl,

            onFieldSubmitted: (String value) {
              if(value.isEmpty){
                setState(() {
                  _helperText = "You can't put empty item is the list";

                });
              } else{
                setState(() {
                  paths.add(value);
                  _helperText = 'Added ${paths.length} items';
                  print(paths);
                });
              }

            },
          ),

          SizedBox(height: 20,),
          Container(

            child: paths.isEmpty ? Center(child: Text('No path list were added'),) :

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: paths.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(index.toString()),
                  ),
                  title: Text(paths[index]),
                  trailing: IconButton(
                      icon: Icon(Icons.delete_outline),
                      onPressed: (){
                        setState(() {
                          paths.remove(paths[index]);
                          _helperText = 'Added ${paths.length} items';

                        });
                      }),
                );
              },
            ),


          ),
        ],
      ),
    );
  }
}
