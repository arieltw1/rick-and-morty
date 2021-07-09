import requests
import json

def main():
    url = 'https://rickandmortyapi.com/api/character/?species=human&status=alive'
    req = requests.get(url)

    #print("HTTP Status Code: " + str(req.status_code))
    #print(req.headers)
    json_obj = json.loads(req.content)

    print(json_obj['info']['count'])
    pages = range(1, int(json_obj['info']['pages']+1))
    print(pages)
    for page in pages:
        for char in json_obj['results']:
            if 'Earth' in char['origin']['name']:
                print(char['name']+", "+char['location']['name']+", "+char['image'])
        req = requests.get(url+"&page="+str(page+1))
        json_obj = json.loads(req.content)

#    print(json_obj['results'])

if __name__ == '__main__':
    main()
