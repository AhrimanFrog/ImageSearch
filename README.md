# Description
Client for a free image API pixabay.com

*API reference:* https://pixabay.com/api/docs/

# Design
<img width="972" alt="Screenshot 2025-03-24 at 18 46 08" src="https://github.com/user-attachments/assets/3a22ff95-a160-40c4-8749-6c4e973ab3b8" />

# Stack
- **MVVM-C** architecture to separate UI from data structures and general logic
- **Combine** for reactive state & UI updates
- **SnapKit** for shorter and more readable constraints
- **IQKeyboard** for simple and easily managable keyboards
- **Hero** for smooth animations
- **TOCropController** for image crop and rotation
- **Photos** to fetch local gallery and save modified images

# Demo
### Search
https://github.com/user-attachments/assets/1118f411-4530-4fa2-8e96-130e5f1833e4

https://github.com/user-attachments/assets/331c5f16-5fbb-4484-a68b-92cb3b998491
### Crop
https://github.com/user-attachments/assets/8abe9c98-29fe-42bd-9818-630f82c3db8b

# Build
Clone project using
`git clone git@github.com:AhrimanFrog/ImageSearch.git`

Open project in Xcode

Wait until package manager resolves dependencies

Replace `<your_key>` with your API key in Config.xcconfig file

Build & Run the project 
