#ifndef BOOK_H
#define BOOK_H

typedef struct {
    const char * const last;
    const char * const middle;
    const char * const first;
    const char * const suffix;
} name;

typedef struct {
    const char *title;
    const char *subtitle;
    name owner;
    int year;
    int edition_num;
    int quantity;
    const char *ISBN;
    const char *binding_type;
    // We can have multiple authors, so support that.
    name *authors;
    // Can also have multiple genres.
    const char *genre[];
} book;

#endif
