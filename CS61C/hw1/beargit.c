#include <stdio.h>
#include <string.h>

#include <unistd.h>
#include <sys/stat.h>

#include "beargit.h"
#include "util.h"

/* Implementation Notes:
 *
 * - Functions return 0 if successful, 1 if there is an error.
 * - All error conditions in the function description need to be implemented
 *   and written to stderr. We catch some additional errors for you in main.c.
 * - Output to stdout needs to be exactly as specified in the function description.
 * - Only edit this file (beargit.c)
 * - You are given the following helper functions:
 *   * fs_mkdir(dirname): create directory <dirname>
 *   * fs_rm(filename): delete file <filename>
 *   * fs_mv(src,dst): move file <src> to <dst>, overwriting <dst> if it exists
 *   * fs_cp(src,dst): copy file <src> to <dst>, overwriting <dst> if it exists
 *   * write_string_to_file(filename,str): write <str> to filename (overwriting contents)
 *   * read_string_from_file(filename,str,size): read a string of at most <size> (incl.
 *     NULL character) from file <filename> and store it into <str>. Note that <str>
 *     needs to be large enough to hold that string.
 *  - You NEED to test your code. The autograder we provide does not contain the
 *    full set of tests that we will run on your code. See "Step 5" in the homework spec.
 */

/* beargit init
 *
 * - Create .beargit directory
 * - Create empty .beargit/.index file
 * - Create .beargit/.prev file containing 0..0 commit id
 *
 * Output (to stdout):
 * - None if successful
 */

int beargit_init(void) {
  fs_mkdir(".beargit");

  FILE* findex = fopen(".beargit/.index", "w");
  fclose(findex);
  
  write_string_to_file(".beargit/.prev", "0000000000000000000000000000000000000000");

  return 0;
}


/* beargit add <filename>
 * 
 * - Append filename to list in .beargit/.index if it isn't in there yet
 *
 * Possible errors (to stderr):
 * >> ERROR: File <filename> already added
 *
 * Output (to stdout):
 * - None if successful
 */

int beargit_add(const char* filename) {
  FILE* findex = fopen(".beargit/.index", "r");
  FILE *fnewindex = fopen(".beargit/.newindex", "w");

  char line[FILENAME_SIZE];
  while(fgets(line, sizeof(line), findex)) {
    strtok(line, "\n");
    if (strcmp(line, filename) == 0) {
      fprintf(stderr, "ERROR: File %s already added\n", filename);
      fclose(findex);
      fclose(fnewindex);
      fs_rm(".beargit/.newindex");
      return 3;
    }

    fprintf(fnewindex, "%s\n", line);
  }

  fprintf(fnewindex, "%s\n", filename);
  fclose(findex);
  fclose(fnewindex);

  fs_mv(".beargit/.newindex", ".beargit/.index");

  return 0;
}


/* beargit rm <filename>
 * 
 * See "Step 2" in the homework 1 spec.
 *
 */

int beargit_rm(const char* filename) {
  FILE* findex = fopen(".beargit/.index", "r");
  FILE *fnewindex = fopen(".beargit/.newindex", "w");
  int correct = 3;
  char line[FILENAME_SIZE];
  while(fgets(line, sizeof(line), findex)) {
    strtok(line, "\n");
    if (strcmp(line, filename) == 0) {
      correct = 0;
    } else {
      fprintf(fnewindex, "%s\n", line);
    }
  }
  
  fclose(findex);
  fclose(fnewindex);

  fs_mv(".beargit/.newindex", ".beargit/.index");

  if (correct == 3) {
    fprintf(stderr, "ERROR: File %s not tracked\n", filename);
  }
  
  return correct;
}

/* beargit commit -m <msg>
 *
 * See "Step 3" in the homework 1 spec.
 *
 */

const char* go_bears = "GO BEARS!";

int is_commit_msg_ok(const char* msg) {
  /* COMPLETE THE REST */
  int consec = 0;
  int i = 0;
  while (msg[i] != NULL) {
    if (msg[i] == 'G' && consec == 0) {
      consec++;
    } else if (msg[i] == 'O' && consec == 1) {
      consec++;
    } else if (msg[i] == ' ' && consec == 2) {
      consec++;
    } else if (msg[i] == 'B' && consec == 3) {
      consec++;
    } else if (msg[i] == 'E' && consec == 4) {
      consec++;
    } else if (msg[i] == 'A' && consec == 5) {
      consec++;
    } else if (msg[i] == 'R' && consec == 6) {
      consec++;
    } else if (msg[i] == 'S' && consec == 7) {
      consec++;
    } else if (msg[i] == '!' && consec == 8) {
      consec++;
    } else {
      consec = 0;
    }

    if (consec == 9) {
      return 1;
    }
    i++;
  }

  return 0;
}

void next_commit_id(char* commit_id) {
  /* COMPLETE THE REST */
  
  if (commit_id[0] == '0') {
    int i = 0;
    while (commit_id[i] != NULL) {
      commit_id[i] = '1';
      i++;
    }
  } else {
    commit_id_helper(commit_id, COMMIT_ID_SIZE - 2);
  }
}

int commit_id_helper(char* commit_id, int pos) {
 if (commit_id[pos] == '1') {
  commit_id[pos] = '6';
 } else if (commit_id[pos] == '6') {
  commit_id[pos] = 'C';
 } else {
  commit_id[pos] = '1';
  commit_id_helper(commit_id, pos - 1);
 }
 return 0;
}

int beargit_commit(const char* msg) {
  if (!is_commit_msg_ok(msg)) {
    fprintf(stderr, "ERROR: Message must contain \"%s\"\n", go_bears);
    return 1;
  }

  char commit_id[COMMIT_ID_SIZE];
  read_string_from_file(".beargit/.prev", commit_id, COMMIT_ID_SIZE);
  next_commit_id(commit_id);
  //printf("%s\n", commit_id);

  char *new_direc = malloc(strlen(".beargit/") + strlen(commit_id) + 1);
  strcpy(new_direc, ".beargit/");
  strcat(new_direc, commit_id);
  fs_mkdir(new_direc); // generating a new directory

  char *new_index = malloc(strlen(new_direc) + strlen("/.index") + 1);
  strcpy(new_index, new_direc);
  strcat(new_index, "/.index");
  fs_cp(".beargit/.index", new_index);

  char *new_prev = malloc(strlen(new_direc) + strlen("/.prev") + 1);
  strcpy(new_prev, new_direc);
  strcat(new_prev, "/.prev");
  fs_cp(".beargit/.prev", new_prev);

  char *new_file = malloc(strlen(new_direc) + strlen("/.msg") + 1);
  strcpy(new_file, new_direc);
  strcat(new_file, "/.msg");
  write_string_to_file(new_file, msg);

  write_string_to_file(".beargit/.prev", commit_id);

  return 0;

}

/* beargit status
 *
 * See "Step 1" in the homework 1 spec.
 *
 */

int beargit_status() {
  /* COMPLETE THE REST */
  FILE* findex = fopen(".beargit/.index", "r");
  char files[FILENAME_SIZE];
  fprintf(stderr, "Tracked files:\n");
  fprintf(stderr, "\n");
  int num_of_files = 0;
  while(fgets(files, sizeof(files), findex)) {
    fprintf(stderr, "  %s", files);
    num_of_files++;
  }
  fprintf(stderr, "\n");
  fprintf(stderr, "%d files total\n", num_of_files);
  return 0;
}

/* beargit log
 *
 * See "Step 4" in the homework 1 spec.
 *
 */

int beargit_log() {
  /* COMPLETE THE REST */
  FILE* commit_names = fopen(".beargit/.prev", "r");
  char commit[COMMIT_ID_SIZE];
  fgets(commit, sizeof(commit), commit_names);

  if (commit[0] == '0') {
    fprintf(stdout, "ERROR: There are no commits!\n");
    return 1;
  }

  fprintf(stderr, "\ncommit %s\n", commit);
  char msg[1000000];
  char *placement = malloc(strlen(".beargit//.msg") + strlen(commit) + 1);
  strcpy(placement, ".beargit/");
  strcat(placement, commit);
  strcat(placement, "/.msg");

  read_string_from_file(placement, msg, 1000000);
  fprintf(stderr, "    %s\n", msg);

  while (is_all_ones(commit) == 1) {
    decrease(commit, COMMIT_ID_SIZE - 2);
    char *pos = malloc(strlen(".beargit//.msg") + strlen(commit) + 1);
    strcpy(pos, ".beargit/");
    strcat(pos, commit);
    strcat(pos, "/.msg");

    fprintf(stderr, "\ncommit %s\n", commit);
    read_string_from_file(pos, msg, 1000000);
    fprintf(stderr, "    %s\n", msg);
  }

  fprintf(stderr, "\n");

  return 0;
}

int is_all_ones(const char* id) {
  for (int i = 2; COMMIT_ID_SIZE - i >= 0; i++) {
    if (id[COMMIT_ID_SIZE - i] != '1') {
      return 1;
    } 
  }
  return 0;
}

int decrease(char* commit_id, int pos) {
  if (commit_id[pos] == 'C') {
    commit_id[pos] = '6';
  } else if (commit_id[pos] == '6') {
    commit_id[pos] = '1';
  } else if (commit_id[pos] == '1') {
    commit_id[pos] = 'C';
    decrease(commit_id, pos - 1);
  }

  return 0;
}
