#ifndef BOOK_H
#define BOOK_H

typedef struct {
    const char *title;
    const char *subtitle;
    // We can have multiple authors, so support that.
    const char *author_last[];
    const char *author_middle[];
    const char *author_first[];
    const char *author_suffix[];
    const char *owner_last;
    const char *owner_middle;
    const char *owner_first;
    const char *owner_suffix;
    int year;
    int quantity;
    const char *ISBN;
    const char *binding_type;
    // Can also have multiple genres.
    const char *genre[];
} book;
