#/usr/bin/env python
# -*- coding: utf-8 -*-
from flask import Response
from flask import request
from flask_restful_swagger_2 import swagger, Resource
import json
import logging
import traceback
import sys
sys.path.append('..')
from db import fake_db_data
from languageConvert.langconv import Converter


def jsonLoads(request_stream):
    try:
        return json.loads(Converter('zh-hant').convert(request_stream.read().decode('utf-8')))
    except Exception as e:
        print('Error: Check out your header/body!Something went wrong or missing!')
        print(except_raise(e))
    return {}

def except_raise(e):
    error_class = e.__class__.__name__ #取得錯誤類型
    detail = e.args[0] #取得詳細內容
    cl, exc, tb = sys.exc_info() #取得Call Stack
    lastCallStack = traceback.extract_tb(tb)[-1] #取得Call Stack的最後一筆資料
    fileName = lastCallStack[0] #取得發生的檔案名稱
    lineNum = lastCallStack[1] #取得發生的行號
    funcName = lastCallStack[2] #取得發生的函數名稱
    errMsg = f"File \"{fileName}\", line {lineNum}, in {funcName}: [{error_class}] {detail}"
    return errMsg