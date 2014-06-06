global class PlaceMapController {
    @RemoteAction
    global static  List<Place__c> search(String name, String tags) {
        if (tags == null || tags == '') tags = '';
        String soql = 'Select Place__r.Name, Place__r.Location__latitude__s, Place__r.Location__longitude__s From PlaceTagReference__c ' +
            ' Where PlaceTag__c In :tagsList ';
        List<String> tagsList = tags.split(',');
        List<Place__c> places = new List<Place__c>();
        if (name != null && name != '') {
            soql += 'And Place__r.Name like \'%' + String.escapeSingleQuotes(name) + '%\'';
        }
        List<PlaceTagReference__c> tmp = Database.query(soql);
        soql += ' Limit 10000';
        for (PlaceTagReference__c t : tmp) {
            places.add(t.Place__r);
        }
        return places;
    }

    @RemoteAction
    global static List<PlaceTag__c> placeTags() {
        return [Select Name, IconURL__c, Color__c From PlaceTag__c Order By Name];
    }

    @RemoteAction
    global static Place__c addPlace(String name, Decimal lat, Decimal lng, String tags) {
        List<String> tagsList = tags.split(',');
        Place__c place = new Place__c(
            Name = name,
            Location__latitude__s = lat,
            Location__longitude__s = lng
        );
        insert place;

        List< PlaceTagReference__c > placeTagReferences = new List<PlaceTagReference__c>();
        for (String tag : tagsList) {
            placeTagReferences.add(new PlaceTagReference__c(
                Place__c = place.Id,
                PlaceTag__c = tag
            ));
        }
        insert placeTagReferences;

        return place;
    }
}