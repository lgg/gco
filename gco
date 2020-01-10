#!/usr/bin/env bash
# Base script for argument parsing: https://github.com/mattbryson/bash-arg-parse
# Script for git clone and open project in specified JetBrains IDE
# By default this script converts any git_url to ssh url (git@), to avoid this: use -o flag

# abort on error
set -e

app="" # app for opening in
convert_url=1 # flag for converting git url to ssh

function usage
{
  printf "Script for git clone and open project in specified JetBrains IDE\n"
  printf "By default this script converts any git_url to ssh url (git@), to avoid this: use -o flag\n\n"
  echo "Usage: gco -APP URL [FOLDER]"
  echo "   ";
  echo "  -i  | --idea                         : Open project in Idea";
  echo "  -r  | --rider                        : Open project in Rider";
  echo "  -c  | --clion                        : Open project in CLion";
  echo "  -d  | --datagrip                     : Open project in DataGrip";
  echo "  -a  | --appcode                      : Open project in AppCode";
  echo "  -rm | --rubymine                     : Open project in RubyMine";
  echo "  -ph | --phpstorm                     : Open project in PhpStorm";
  echo "  -w  | --webstorm                     : Open project in WebStorm";
  echo "  -p  | --pycharm                      : Open project in PyCharm";
  echo "  -pp | --pycharm-professional         : Open project in PyCharm Professional";
  echo "  -o  | --original_url                 : Disable git_url converting to ssh url";
  echo "  -h  | --help                         : Show help";
  echo "   ";
  echo "Example: gco -w https://github.com/lgg/gco gco-script";
  echo "   ";
  echo "Command above: convert URL to git@github.com:lgg/gco.git";
  echo "git clone project to gco-script folder and open it in WebStorm";
  echo "   ";
  exit 1
}

function parse_args
{
  # positional args
  args=()

  # named args
  while [[ "$1" != "" ]]; do
    case "$1" in
      -i  | --idea )                     app="idea";                 shift 0;;
      -r  | --rider )                    app="rider";                shift 0;;
      -c  | --clion )                    app="clion";                shift 0;;
      -d  | --datagrip )                 app="datagrip";             shift 0;;
      -a  | --appcode )                  app="appcode";              shift 0;;
      -rm | --rubymine )                 app="rubymine";             shift 0;;
      -ph | --phpstorm )                 app="phpstorm";             shift 0;;
      -w  | --webstorm )                 app="webstorm";             shift 0;;
      -p  | --pycharm )                  app="pycharm";              shift 0;;
      -pp | --pycharm-professional)      app="pycharm-professional"; shift 0;;
      -o  | --original_url )             convert_url=0;              shift 0;;
      -h  | --help )                     usage;                      exit;; # quit and show usage
      * )                                args+=("$1")                # if no match, add it to the positional args
    esac
    shift # move to next kv pair
  done

  # restore positional args
  set -- "${args[@]}"

  # set positionals to vars
  positional_1="${args[0]}"
  positional_2="${args[1]}"

  # validate required args
  if [[ -z "${app}" ]]; then
    echo "   ";
    echo "ERROR: APP missing"
    echo "   ";
    usage
    exit 0
  fi
}

function run
{
  # parse flags and arguments
  parse_args "$@"

  gco
}

function gco
{
  repoUrl="$positional_1"
  repoName="$positional_2"

  # remove trailing slash if it exists
  repoUrl=${repoUrl%/}

  # check if we need to convert git url to ssh
  if [[ "$convert_url" = 1 ]]; then
    git_url=""
    url="$repoUrl"
    # check if we have git@ url and rewrite it to git@
    if [[ "${url%@*}" = "git" ]]; then
      git_url="$url"
    elif [[ "${url%://*}" = "https" ]]; then
      url="${url/.git}"
      domain="${url#*https:\/\/}"
      domain="${domain/\/*}"
      project_url="${url#*https:\/\/$domain\/}"
      git_url="git@""$domain"":""$project_url"".git"
      repoUrl="$git_url"
    else
      echo "   ";
      echo "ERROR: Unknown git url type (ssh/https)"
      echo "   ";
      usage;
      exit 0
    fi
  fi
  printf "Project url: %s\n" "$repoUrl"

  # parse project name
  if [[ "$repoName" = "" ]]; then
    printf "No project name specified. Parsing it from url...\n"
    repoName="${repoUrl##*/}"
    repoName="${repoName/.git/}"
  fi
  printf "Project name: %s\n" "$repoName"

  # git clone project
  git clone "$repoUrl" "$repoName"

  # cd to project
  cd "$repoName" || exit 0

  # open in app
  ${app} . >> /dev/null &
  exit 1
}

run "$@";
