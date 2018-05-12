//
//  main.swift
//  GBPods-Template
//
//  Created by 张行 on 2018/5/11.
//  Copyright © 2018年 张行. All rights reserved.
//

import Foundation

class PodsTemplate {
    let podName:String
    init(podName:String) {
        self.podName = podName
    }
    func initTemplate() {
        guard let path = ProcessInfo.processInfo.environment["PWD"] else {
            return
        }
        try? FileManager.default.removeItem(atPath: "\(path)/GBPods-Template")
        repleacePodName(filePath: path)
    }
    
    func repleacePodName(filePath:String) {
        var isDirectory = ObjCBool(booleanLiteral: false)
        guard FileManager.default.fileExists(atPath: filePath, isDirectory: &isDirectory) else {
            return
        }
        let findPath = copyFilePath(filePath: filePath, isDirectory: isDirectory.boolValue)
        if isDirectory.boolValue {
            guard let contents = try? FileManager.default.contentsOfDirectory(atPath: findPath) else {
                return
            }
            for subPath in contents {
                repleacePodName(filePath: "\(findPath)/\(subPath)")
            }
            
        } else {
            guard var content = try? String(contentsOfFile: findPath) else {
                return
            }
            content = content.replacingOccurrences(of: "POD_NAME", with: podName)
            let url = URL(fileURLWithPath: findPath)
            try? content.write(to: url, atomically: true, encoding: String.Encoding.utf8)
        }
    }
    
    func copyFilePath(filePath:String, isDirectory:Bool) -> String {
        if let _ = filePath.range(of: "POD_NAME") {
            let newFilePath = filePath.replacingOccurrences(of: "POD_NAME", with: podName)
            if isDirectory {
                try? FileManager.default.copyItem(atPath: filePath, toPath: newFilePath)
                try? FileManager.default.removeItem(atPath: filePath)
            } else {
                let url1 = URL(fileURLWithPath: filePath)
                let url2 = URL(fileURLWithPath: newFilePath)
                try? FileManager.default.copyItem(at: url1, to: url2)
                try? FileManager.default.removeItem(at: url1)
            }
            return newFilePath
        }
        return filePath
    }
    
}
print("请输入 Pod 名字:")
if let podName = readLine() {
    PodsTemplate(podName:podName).initTemplate()
}

