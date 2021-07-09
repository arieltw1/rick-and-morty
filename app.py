import requests
import json
import csv

def main():
    url = 'https://rickandmortyapi.com/api/character/?species=human&status=alive'
    req = requests.get(url)
    json_obj = json.loads(req.content)

    pages = range(1, int(json_obj['info']['pages']+1))

    csv_file = open("results.csv", "w") 
    data = [['Name', 'Location', 'Image']]

    for page in pages:
        for char in json_obj['results']:
            if 'Earth' in char['origin']['name']:
                data.append([char['name'], char['location']['name'], char['image']])
                #csv.writer(csv_file).writerow(data)

        req = requests.get(url+"&page="+str(page+1))
        json_obj = json.loads(req.content)

    csv.writer(csv_file).writerows(data)
    csv_file.close()

if __name__ == '__main__':
    main()
