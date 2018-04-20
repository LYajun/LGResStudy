#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LGDic.h"
#import "DLGBasePresenter.h"
#import "DLGButton.h"
#import "DLGViewTransferProtocol.h"
#import "DLGHttpClient.h"
#import "DLGHttpPresenter.h"
#import "DLGHttpResponseProtocol.h"
#import "DLGAlert.h"
#import "DLGCommon.h"
#import "DLGConfig.h"
#import "DLGPlayer.h"
#import "DLGProgressHUD.h"
#import "DLGRecorder.h"
#import "DLGDicViewController.h"
#import "DLGDicPresenter.h"
#import "DLGSearchTextField.h"
#import "DLGRecordCell.h"
#import "DLGRecordTable.h"
#import "DLGRecordViewController.h"
#import "DLGResultViewController.h"
#import "DLGWordCategoryModel.h"
#import "DLGWordModel.h"
#import "DLGResultTableParseProtocol.h"
#import "DLGResultTablePresenter.h"
#import "DLGResultTable.h"
#import "DLGResultTableHeader.h"
#import "DLGResultTextCell.h"
#import "DLGResultVoiceCell.h"

FOUNDATION_EXPORT double LGDicVersionNumber;
FOUNDATION_EXPORT const unsigned char LGDicVersionString[];

