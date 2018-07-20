def get_palindromes(file):
    palindromes = []

    with open(file, "r") as f:
        c = f.readlines()

    for line in c:
        word = line.strip()
        if word == word[::-1]:
            palindromes.append(word)

    return palindromes


def main():
    in_file = ".\\dicts\\alphabetical.txt"
    p = get_palindromes(in_file)

    return len(p)


if __name__ == '__main__':
    print(main())
