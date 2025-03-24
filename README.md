# 📱 Location Tracker

An iOS application developed as a case study for the Martı iOS Developer position. The app tracks user location and visualizes it on a map. This app records user movements by monitoring location changes both in the foreground and background.

## ✨ Features

- 🗺️ Real-time location tracking
- 📍 Adding markers to the map every 100 meters
- 🏃‍♂️ Foreground and background location tracking support
- 🏠 Display address information when tapping on markers
- ⏯️ Start/stop location tracking control
- 🔄 Option to reset the route

## 🛠️ Technologies

- UIKit
- MVVM Architecture Pattern
- CoreLocation
- Google Maps SDK
- CoreData

## 🏗️ Project Structure

The application is structured using the MVVM architecture:

- **Model**: Represents location data
- **View**: User interface components and map view
- **ViewModel**: Processes location data and prepares it for the View

## 🔧 Installation

Clone the project:
```bash
git clone https://github.com/aisenurmor/LocationTracker.git
```

- Open the project in Xcode
- Wait for dependencies to resolve
- Run the project

## 📝 Usage

- Location permission will be requested when the app starts
- Location tracking starts when you tap the start button
- Control tracking with the Start/Stop button
- Clear all markers with the reset button
- View address information by tapping on markers

## 📋 Requirements

- iOS 17.0 or higher
- Xcode 16.0 or higher
- Google Maps API key
- Location permission

## 📜 License
[MIT](https://choosealicense.com/licenses/mit/)
