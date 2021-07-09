import requests
import json
import csv

def main():

    # get first page of characters and the amount of pages needed from the API
    url = 'https://rickandmortyapi.com/api/character/?species=human&status=alive'
    req = requests.get(url)
    # load json object from the response
    json_obj = json.loads(req.content)
    # set pages range so we'll be able to loop over them 
    pages = range(1, int(json_obj['info']['pages']+1))

    # open and create the csv file
    csv_file = open("results.csv", "w") 
    # define the csv headers
    data = [['Name', 'Location', 'Image']]
    
    # loop over the pages and look for characters from earth
    for page in pages:
        for char in json_obj['results']:
            # if character is from earth, add it to data
            if 'Earth' in char['origin']['name']:
                data.append([char['name'], char['location']['name'], char['image']])
        
        # if its not the last page, get the next page and load it as json
        if page != pages[-1]:
            req = requests.get(url+"&page="+str(page+1))
            json_obj = json.loads(req.content)

    # write all the data to the csv file and close it
    csv.writer(csv_file).writerows(data)
    csv_file.close()

if __name__ == '__main__':
    main()
