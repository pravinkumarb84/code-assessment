import json
import argparse


def parse_object():
        parser = argparse.ArgumentParser(
                description='object and key')
        parser.add_argument('--object',required=True)
        parser.add_argument('--key',required=True,default=None)
        args = parser.parse_args()
        key_value = args.key.split("/")
        x = json.loads(args.object)

        i = 1;
        while i <= len(key_value):
                for key in x:
                        if type(x[key]) is dict and key in key_value:
                                x = x[key]
                                i+= 1
                        elif type(x[key]) is str:
                                x = x[key]
                                i+= 1
                                break
        return x


if __name__ == '__main__':
        print(parse_object())