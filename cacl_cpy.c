#include "stdio.h"
#include "stdlib.h"

struct e {
  enum { e_EInt,e_EAdd,e_ESub } tag;
  union {
    struct {
      int i;
    } EInt;
    struct {
      struct e* e1;
      struct e* e2;
    } EAdd;
    struct {
      struct e* e1;
      struct e* e2;
    } ESub;
  };
};

struct e* EInt(int i) {
  struct e *e = (struct e*)malloc(sizeof(struct e));
  e->tag = e_EInt;
  e->EInt.i = i;
  return e;
}

struct e* EAdd(struct e* e1, struct e* e2) {
  struct e *e = (struct e*)malloc(sizeof(struct e));
  e->tag = e_EAdd;
  e->EAdd.e1 = e1;
  e->EAdd.e2 = e2;
  return e;
}

struct e* ESub(struct e* e1, struct e* e2) {
  struct e *e = (struct e*)malloc(sizeof(struct e));
  e->tag = e_ESub;
  e->ESub.e1 = e1;
  e->ESub.e2 = e2;
  return e;
}

struct e* e_copy(struct e* e) {
  switch (e->tag) {
    case e_EInt: return EInt(e->EInt.i);
    case e_EAdd: return EAdd(e_copy(e->EAdd.e1), e_copy(e->EAdd.e2));
    case e_ESub: return ESub(e_copy(e->ESub.e1), e_copy(e->ESub.e2));
  }
}

void e_free(struct e* e) {
  switch (e->tag) {
    case e_EInt:
      {
        free(e);
        break;
      }
    case e_EAdd:
      {
        struct e* e1 = e->EAdd.e1;
        struct e* e2 = e->EAdd.e2;
        free(e);
        e_free(e1);
        e_free(e2);
        break;
      }
    case e_ESub:
      {
        struct e* e1 = e->ESub.e1;
        struct e* e2 = e->ESub.e2;
        free(e);
        e_free(e1);
        e_free(e2);
        break;
      }
  }
}


int e_eval(struct e* e) {
  switch (e->tag) {
    case e_EInt: return e->EInt.i;
    case e_EAdd: return e_eval(e->EAdd.e1) + e_eval(e->EAdd.e2);
    case e_ESub: return e_eval(e->ESub.e1) - e_eval(e->ESub.e2);
  }
}

int e_free_eval(struct e* e) {
  switch (e->tag) {
    case e_EInt:
      {
        int i = e->EInt.i;
        free(e);
        return i;
      }
    case e_EAdd:
      {
        struct e* e1 = e->EAdd.e1;
        struct e* e2 = e->EAdd.e2;
        free(e);
        return e_free_eval(e1) + e_free_eval(e2);
      }
    case e_ESub:
      {
        struct e* e1 = e->EAdd.e1;
        struct e* e2 = e->EAdd.e2;
        free(e);
        return e_free_eval(e1) - e_free_eval(e2);
      }
  }
}

void e_print(struct e* e) {
  switch (e->tag) {
    case e_EInt: printf("EInt(%d)", e->EInt.i); break;
    case e_EAdd:
      printf("EAdd(");
      e_print(e->EAdd.e1);
      printf(",");
      e_print(e->EAdd.e2);
      printf(")");
      break;
    case e_ESub:
      printf("EAdd(");
      e_print(e->EAdd.e1);
      printf(",");
      e_print(e->EAdd.e2);
      printf(")");
      break;
  }
}

int main() {
  
  struct e* e1 = EAdd(EInt(1),EInt(2));
  e_print(e1); printf("\n");
  printf("%d", e_eval(e1)); printf("\n");
  e_free(e1);  

  printf("%d", e_free_eval(EAdd(EInt(1),EInt(2)))); printf("\n");

  struct e* e2 = EAdd(EInt(1),EInt(2));
  e_print(e2); printf("\n");
  struct e* e3 = e_copy(e2);
  printf("%d", e_free_eval(e2)); printf("\n");
  printf("%d", e_free_eval(e3)); printf("\n");

  return 0;
}
