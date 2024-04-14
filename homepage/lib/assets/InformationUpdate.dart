class InformationUpdate{
  String _ID = "";
  String _imageUrlPath = "";
  String _description = "";
  String _fullStory = "";
  String _datePosted = "";
  String _estimatedReadTime = "";

  void setID(String ID){
    _ID = ID;
  }

  void setImageUrlPath(String url){
    _imageUrlPath = url;
  }

  void setDescription(String StoryDescription){
    _description = StoryDescription;
  }

  void setFullStory(String fullStory){
    _fullStory = fullStory;
  }

  void setDatePosted(String datePosted){
    _datePosted = datePosted;
  }

  void setEstimatedReadTime(String estimatedReadingTime){
    _estimatedReadTime = estimatedReadingTime;
  }

  String getID(){
    return _ID;
  }

  String getImageUrlPath(){
    return _imageUrlPath;
  }

  String getDescription(){
    return _description;
  }

  String getFullStory(){
    return _fullStory;
  }

  String getDatePosted(){
    return _datePosted;
  }

  String getEstimatedReadTime(){
    return _estimatedReadTime;
  }

  int addInformationUpdateToDatabase(){
    //To be implemented
    return 1;
  }

  int editInformationUpdateOnDatabase(String ID){
    //To be implemented
    return 1;
  }

  int DeleteInformationUpdateFromDatabase(String ID){
    //To be implemented
    return 1;
  }
}