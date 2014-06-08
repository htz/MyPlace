@isTest
private class PlaceMapControllerTest {
    static ID newTag(String name, String color, String icon) {
        PlaceTag__c tag = new PlaceTag__c(
            Name = name,
            Color__c = color,
            IconURL__c = icon
        );
        insert tag;
        return tag.Id;
    }

    static testMethod void allTest() {
        ID tagId = newTag('hoge', '#ff00ff', '/test.png');
        PlaceMapController.placeTags();
        PlaceMapController.addPlace('test', 'address', 0, 0, tagId); 
        PlaceMapController.search('test', tagId);
        PlaceMapController.search('test', null);
    }
}