from collections import Counter
import sys

def get_palindromes(file, letters):
    words = []
    l_count = Counter(letters)

    with open(file, "r") as f:
        c = f.readlines()

    for line in c:
        test = True
        word = line.strip()
        w_count = Counter(word)

        for elem in w_count:
            if w_count[elem] <= l_count[elem]:
                continue
            else:
                test = False
                break

        if test:
            words.append(word)

    return words

def main():
    in_file = "C:\\Users\\Patrick\\Documents\\programming\\powershell\\projects\\palendromes\\enable1.txt"
    p = get_palindromes(in_file, "abcdefg")

    return p

if __name__ == '__main__':
    print(main())
