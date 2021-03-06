global class PlaceMapController {
    @RemoteAction
    global static  List<Place__c> search(String name, String tags) {
        if (tags == null || tags == '') {
            String soql = 'Select Name, Location__latitude__s, Location__longitude__s From Place__c ' +
                'Where Id != NULL ';
            if (name != null && name != '') {
                soql += 'And Name like \'%' + String.escapeSingleQuotes(name) + '%\' ';
            }
            soql += 'Limit 10000';
            return Database.query(soql);
        } else {
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
    }

    @RemoteAction
    global static List<PlaceTag__c> placeTags() {
        return [Select Name, IconURL__c, Color__c From PlaceTag__c Where IsActive__c = true Order By Name];
    }

    @RemoteAction
    global static Place__c addPlace(String name, String address, Decimal lat, Decimal lng, String tags) {
        if (name == null || lat == null || lng == null) return null;

        Place__c place = new Place__c(
            Name = name,
            Address__c = address,
            Location__latitude__s = lat,
            Location__longitude__s = lng
        );
        insert place;

        if (tags != null && tags != '') {
            List<String> tagsList = tags.split(',');
            List< PlaceTagReference__c > placeTagReferences = new List<PlaceTagReference__c>();
            for (String tag : tagsList) {
                placeTagReferences.add(new PlaceTagReference__c(
                    Place__c = place.Id,
                    PlaceTag__c = tag
                ));
            }
            insert placeTagReferences;
        }

        return place;
    }
}