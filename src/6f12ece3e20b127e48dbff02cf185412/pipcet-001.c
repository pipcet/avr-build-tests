extern int f(void);
extern int g(void);
extern int h(void);

int main(int argc, char **argv)
{
  if (argc < 0)
    f();
  else if (argc == 0)
    g();
  else
    h();
}
