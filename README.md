#  Event Diary

## Description

Event Diary is a native iOS application that lets users create and log any events they have experienced. 
Users can add photos, descriptions, and even tasks they have or would like the accomplish. 
Firebase Authentication and Firestore are used to save and store data.  

![](https://github.com/rzheng2019/EventDiary/blob/main/EventDiaryGif.gif)

## Getting Started

1. Make sure to have XCode Version 14.3.1 or above installed on your computer.
2. Open the project files in XCode.
3. Build and run project (preferably on iPhone 14 versions).
4. (Optional) Sign up for an account if you don't have an account already by pressing sign up button.
5. Login to account
6. Add and modify events accordingly.

## Architecture

- Event Diary was implemented using Model View View-Model (MVVM) archiecture.

## Structure

- "Models": Files that cointain the models for what a event item and check list item consists of.
- "View Models": Files that contain the view models that provide data and functionality to be used by views.
- "Views": Files that use view models to display user interface with data.
