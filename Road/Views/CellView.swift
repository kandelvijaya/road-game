//
//  CellView.swift
//  Road
//
//  Created by Yunus Eren Guzel on 28/08/15.
//  Copyright (c) 2015 yeg. All rights reserved.
//

import UIKit

enum CellType {
    case passive, active
}

enum CellState {
    case hightlighted, normal
}

enum Direction {
    case North,South,West,East
}

class CellView: UIView {
    struct Connection {
        var north:CellView?
        var south:CellView?
        var west:CellView?
        var east:CellView?
    }
    
    struct ConnectionView {
        var north = UIView()
        var south = UIView()
        var west = UIView()
        var east = UIView()
    }
    
    var point:Map.Point!
    
    var state:CellState! = CellState.normal {
        didSet {
            configureViews()
        }
    }
    
    var connection:Connection = Connection()
    private var connectionView:ConnectionView = ConnectionView()
    
    var cellType:CellType! {
        didSet {
            configureViews()
        }
    }
    var label = UILabel()
    
    init() {
        super.init(frame: CGRect.zero)
        initViews()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    func redirectedCellFrom(cell:CellView?) -> CellView? {
        if(connection.north != cell && connection.north != nil) {
            return connection.north
        }
        else if (connection.south != cell && connection.south != nil) {
            return connection.south
        }
        else if (connection.west != cell && connection.west != nil) {
            return connection.west
        }
        else if (connection.east != cell && connection.east != nil) {
            return connection.east
        }
        else {
            return nil;
        }
    }
    
    func clearConnections(){
        //    clear any connection for any direction. make the connection nil before calling disconnectFrom
        if let cell = connection.north {
            connection.north = nil
            cell.disconnectFrom(self)
        }
        if let cell = connection.south {
            connection.south = nil
            cell.disconnectFrom(cell)
        }
        if let cell = connection.east {
            connection.east = nil
            cell.disconnectFrom(self)
        }
        if let cell = connection.west {
            connection.west = nil
            cell.disconnectFrom(self)
        }
        configureViews()
    }
    func disconnectFrom(cell:CellView) {
        // check for all directions and then call configure views if any connection is set to nil
        if connection.east == cell {
            connection.east = nil
            configureViews()
            if cell.connection.west == self {
                cell.disconnectFrom(self)
            }
        }
        else if connection.north == cell {
            connection.north = nil
            configureViews()
            if cell.connection.south == self {
                cell.disconnectFrom(self)
            }
        }
        else if connection.south == cell {
            connection.south = nil
            configureViews()
            if cell.connection.north == self {
                cell.disconnectFrom(self)
            }
        }
        else if connection.west == cell {
            connection.west = nil
            configureViews()
            if cell.connection.east == self {
                cell.disconnectFrom(self)
            }
        }
    }
    
    
    func connectionCount() -> Int {
        return (connection.west != nil ? 1 : 0) +
            (connection.east != nil ? 1 : 0) +
            (connection.north != nil ? 1 : 0) +
            (connection.south != nil ? 1 : 0)
    }
    
    func connectOrDisconnect(cell:CellView) -> Bool {
        if let direction = findDirection(cell) as Direction! {
            var isConnected = false
            switch direction {
            case .North:
                isConnected = self.connection.north == cell
            case .South:
                isConnected = self.connection.south == cell
            case .West:
                isConnected = self.connection.west == cell
            case .East:
                isConnected = self.connection.east == cell
            }
            if isConnected {
                disconnectFrom(cell)
                return true
            } else {
                return connectWith(cell)
            }
        }
        return false
        
    }
    
    func connectWith(cell:CellView) -> Bool {
        if connectionCount() > 1 {
            return false
        }
        if let direction = findDirection(cell) as Direction! {
            switch direction {
            case .North:
                connection.north = cell
                if cell.connection.south == nil {
                    cell.connectWith(self)
                }
            case .South:
                connection.south = cell
                if cell.connection.north == nil {
                    cell.connectWith(self)
                }
            case .West:
                connection.west = cell
                if cell.connection.east == nil {
                    cell.connectWith(self)
                }
            case .East:
                connection.east = cell
                if cell.connection.west == nil {
                    cell.connectWith(self)
                }
            }
            configureViews()
            return true
        }
        return false
    }
    func findDirection(cell:CellView) -> Direction? {
        
        if cell == self {
            return nil
        }
        if cell.cellType == CellType.passive {
            return nil
        }
        
        if point.x == cell.point.x {
            if point.y == cell.point.y + 1  { // north
                if cell.connectionCount() > 1 && cell.connection.south == nil {
                    return nil
                }
                return Direction.North
            }
            else if point.y + 1 == cell.point.y { // south
                if cell.connectionCount() > 1 && cell.connection.north == nil {
                    return nil
                }
                return Direction.South
            }
        }
        else if point.y == cell.point.y {
            if point.x == cell.point.x + 1 { // west
                if cell.connectionCount() > 1 && cell.connection.east == nil {
                    return nil
                }
                return Direction.West
            }
            else if point.x + 1 == cell.point.x { // east
                if cell.connectionCount() > 1 && cell.connection.west == nil {
                    return nil
                }
                return Direction.East
            }
        }
        return nil
    }
    
    private func initViews() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = NSTextAlignment.Center
        addSubview(label)
        
        connectionView.west.translatesAutoresizingMaskIntoConstraints = false
        connectionView.west.backgroundColor = UIColor.blackColor()
        connectionView.west.hidden = true
        addSubview(connectionView.west)
        
        connectionView.east.translatesAutoresizingMaskIntoConstraints = false
        connectionView.east.backgroundColor = UIColor.blackColor()
        connectionView.east.hidden = true
        addSubview(connectionView.east)
        
        connectionView.north.translatesAutoresizingMaskIntoConstraints = false
        connectionView.north.backgroundColor = UIColor.blackColor()
        connectionView.north.hidden = true
        addSubview(connectionView.north)
        
        connectionView.south.translatesAutoresizingMaskIntoConstraints = false
        connectionView.south.backgroundColor = UIColor.blackColor()
        connectionView.south.hidden = true
        addSubview(connectionView.south)
        
        let views = [
            "label":label,
            "west":connectionView.west,
            "east":connectionView.east,
            "north":connectionView.north,
            "south":connectionView.south
        ]
        let metrics  = [
            "stroke":5
        ]
        addConstraints(NSLayoutConstraint
            .constraintsWithVisualFormat("H:|[label]|", options: [], metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint
            .constraintsWithVisualFormat("V:|[label]|", options: [], metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint
            .constraintsWithVisualFormat("V:|-0-[north]-0-[south(north)]-0-|",
                options: NSLayoutFormatOptions.AlignAllCenterX, metrics: metrics, views: views))
        addConstraint(NSLayoutConstraint(item: connectionView.north, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraints(NSLayoutConstraint
            .constraintsWithVisualFormat("H:[north(stroke)]", options: [], metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint
            .constraintsWithVisualFormat("H:[south(stroke)]", options: [], metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint
            .constraintsWithVisualFormat("H:|-0-[west]-0-[east(west)]-0-|",
                options: NSLayoutFormatOptions.AlignAllCenterY, metrics: metrics, views: views))
        addConstraint(NSLayoutConstraint(item: connectionView.west, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        addConstraints(NSLayoutConstraint
            .constraintsWithVisualFormat("V:[west(stroke)]", options: [], metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint
            .constraintsWithVisualFormat("V:[east(stroke)]", options: [], metrics: metrics, views: views))
    }
    
    func configureViews() {
        if cellType == CellType.active {
            if state == CellState.hightlighted {
                backgroundColor = UIColor.lightGrayColor()
            } else {
                backgroundColor = UIColor.whiteColor()
            }
        } else {
            backgroundColor = UIColor.grayColor()
        }
        connectionView.north.hidden = connection.north == nil
        connectionView.east.hidden = connection.east == nil
        connectionView.south.hidden = connection.south == nil
        connectionView.west.hidden = connection.west == nil
    }
    
    
    
}
