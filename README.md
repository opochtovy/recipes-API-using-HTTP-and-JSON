recipes-API-using-HTTP-and-JSON

=====================================================

That app illustrates how to create application for collection of turn-based recipes for iPad. 

The app has 2 screens. First screen shows a collection of recipes (preview image and name) using UICollectionView. Second screen illustrates a recipe profile. Images are downloaded from server and saved locally. All text information is taken from local JSON file.

During my app’s realization I touched the following topics:

- basics of client-server API (HTTP);
- how to load images from server using AFNetworking;
- how to load images from server using standard methods of Apple;
- how to use JSON data from file and serialize it;
- creating custom UIButtons;
- creating custom collectionView in code;
- creating custom singleton;
- creating custom cell;
- customization of UINavBar & UITabBar.