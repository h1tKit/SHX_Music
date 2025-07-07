cmake_minimum_required(VERSION 3.27)

project(
  SHXM
  VERSION 0.1
  LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS Widgets Qml Quick)
find_package(Taglib REQUIRED)

include_directories(${TAGLIB_INCLUDE_DIRS})

qt_standard_project_setup(REQUIRES 6.9)

qt_add_executable(appSHXM)

qt_add_qml_module(
  appSHXM
  URI
  SHXM
  VERSION
  1.0
  SOURCES
  main.cpp
  QML_FILES
  Main.qml
  QML_FILES
  qml/logic/Player.qml
  QML_FILES
  qml/conponents/PlayBar.qml
  qml/conponents/RoundRectangleButton.qml
  qml/conponents/RoundWindow.qml
  qml/conponents/TSlider.qml
  QML_FILES
  qml/logic/ControlPlay.qml
  SOURCES
  heads/musicpathoperations.h
  SOURCES
  heads/musicinfo.h
  SOURCES
  cpp/musicinfo.cpp
  cpp/musicpathoperations.cpp
  QML_FILES
  QML_FILES
  qml/conponents/SideMenu.qml
  RESOURCES
  image/brightness.png
  image/delete.png
  image/loop.png
  image/love_empty.png
  image/love.png
  image/musiclist.png
  image/night.png
  image/pause.png
  image/play.png
  image/random.png
  image/single_loop.png
  image/skip_next.png
  image/skip_previous.png
  image/volume_mute.png
  image/volume.png
  RESOURCES
  icon.qrc
  QML_FILES
  qml/conponents/LocalPage.qml
  QML_FILES
  QML_FILES
  qml/conponents/VolumeSlider.qml

  QML_FILES
  QML_FILES
  QML_FILES
  qml/conponents/HSlider.qml
  SOURCES
  cpp/musicmodel.cpp
  SOURCES
  heads/musicmodel.h
  QML_FILES
  RESOURCES
  data/currentMusic.txt
  QML_FILES
  RESOURCES
  data/localMusic.txt
  SOURCES
  heads/fileOperations.h
  SOURCES
  cpp/fileOperations.cpp
  RESOURCES
  data/favoriteMusic.txt
  QML_FILES
  qml/conponents/FavoritePage.qml
  SOURCES
  heads/searchmusic.h
  SOURCES
  cpp/searchmusic.cpp
  QML_FILES
  qml/conponents/MusicFileDialog.qml
  SOURCES
  heads/imageproviader.h
  SOURCES
  cpp/imageproviader.cpp
  SOURCES
  heads/lyricparser.h
  SOURCES
  cpp/lyricparser.cpp
  QML_FILES
  qml/conponents/LrcDisplay.qml
  SOURCES

  SOURCES

  RESOURCES data/empty.lrc
  QML_FILES qml/conponents/SearchBar.qml)

target_compile_features(appSHXM PRIVATE cxx_std_23)

target_link_libraries(appSHXM PRIVATE Qt6::Quick)
target_link_libraries(appSHXM PRIVATE Qt6::Widgets Qt6::Qml Qt6::Quick)
target_link_libraries(appSHXM PRIVATE TagLib::TagLib)
target_link_libraries(appSHXM PRIVATE Qt6::Concurrent)

set_target_properties(
  appSHXM
  PROPERTIES # MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appSHXM
             MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
             MACOSX_BUNDLE_SHORT_VERSION_STRING
             ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
             MACOSX_BUNDLE TRUE
             WIN32_EXECUTABLE TRUE)

include(GNUInstallDirs)
install(
  TARGETS appSHXM
  BUNDLE DESTINATION .
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

# set(CMAKE_CXX_STANDARD_REQUIRED ON) # Globally preventing the fallback
# behaviour of C++ standard qt_add_executable(SHXM)  //Creates and finalizes an
# application target of a platform-specific type. This command performs the
# following tasks: 1. Create a CMake target of the appropriate type for the
# target platform. 2. Link the target to the Qt::Core library. 3. Handle
# finalization of the CMake target.

# set(CMAKE_CXX_STANDARD_REQUIRED ON) # Globally preventing the fallback
# behaviour of C++ standard

# qt_standard_project_setup()  #set(CMAKE_AUTOUIC ON)  set(CMAKE_AUTOMOC ON)

# cmake_minimum_required(VERSION 3.16)
#
# project(SHXM VERSION 0.1 LANGUAGES CXX)
#
# @if !true set(CMAKE_AUTOMOC ON) @endif set(CMAKE_CXX_STANDARD_REQUIRED ON)
#
# find_package(Qt6 REQUIRED COMPONENTS Quick)
#
# @if true @if true qt_standard_project_setup(REQUIRES 6.9) @else
# qt_standard_project_setup() @endif @endif
#
# qt_add_executable(appSHXM main.cpp )
#
# qt_add_qml_module(appSHXM URI SHXM VERSION 1.0 QML_FILES Main.qml )
#
# # Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1. #
# If you are developing for iOS or macOS you should consider setting an #
# explicit, fixed bundle identifier manually though.
# set_target_properties(appSHXM PROPERTIES #    MACOSX_BUNDLE_GUI_IDENTIFIER
# com.example.appSHXM MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
# MACOSX_BUNDLE_SHORT_VERSION_STRING
# ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR} MACOSX_BUNDLE TRUE
# WIN32_EXECUTABLE TRUE )
#
# target_link_libraries(appSHXM PRIVATE Qt6::Quick )
#
# include(GNUInstallDirs) install(TARGETS appSHXM BUNDLE DESTINATION . LIBRARY
# DESTINATION ${CMAKE_INSTALL_LIBDIR} RUNTIME DESTINATION
# ${CMAKE_INSTALL_BINDIR} )
