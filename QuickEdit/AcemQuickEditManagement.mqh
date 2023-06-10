//+------------------------------------------------------------------+
//|                                      AcemQuickEditManagement.mqh |
//|                                         Copyright 2023, Acem0608 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Acem0608"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Acem/QuickEdit/AcemQuickCline.mqh>
#include <Acem/QuickEdit/AcemQuickHline.mqh>
#include <Acem/QuickEdit/AcemQuickVline.mqh>
#include <Acem/QuickEdit/AcemQuickTline.mqh>
#include <Acem/QuickEdit/AcemQuickDelete.mqh>
#include <Acem/QuickEdit/AcemQuickDeselect.mqh>

class CAcemQuickEditManagement : public CAcemBase
{
protected:
    virtual bool OnKeyDown(int id, long lparam, double dparam, string sparam);
    virtual bool OnMouseMove(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectCreate(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectChange(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectDelete(int id, long lparam, double dparam, string sparam);
    virtual bool OnChartClick(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectClick(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectDrag(int id, long lparam, double dparam, string sparam);
    virtual bool OnObjectEndEdit(int id, long lparam, double dparam, string sparam);
    virtual bool OnChartChange(int id, long lparam, double dparam, string sparam);

    CAcemQuickCline m_quickCLine;
    CAcemQuickHline m_quickHLine;
    CAcemQuickVline m_quickVLine;
    CAcemQuickTline m_quickTLine;
    CAcemQuickDelete m_quickDelete;
    CAcemQuickDeselect m_quickDeselect;

public:
    CAcemQuickEditManagement();
    ~CAcemQuickEditManagement();

    virtual bool isEditing();
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickEditManagement::CAcemQuickEditManagement()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CAcemQuickEditManagement::~CAcemQuickEditManagement()
{
}
//+------------------------------------------------------------------+

bool CAcemQuickEditManagement::OnKeyDown(int id, long lparam, double dparam, string sparam)
{
    if (isEditing()) {
        if (m_quickCLine.isEditing()) {
            m_quickCLine.OnKeyDown(id, lparam, dparam, sparam);
        }
        if (m_quickCLine.isEditing()) {
            m_quickCLine.OnKeyDown(id, lparam, dparam, sparam);
        }
    } else {
        m_quickCLine.OnKeyDown(id, lparam, dparam, sparam);
        m_quickHLine.OnKeyDown(id, lparam, dparam, sparam);
        m_quickVLine.OnKeyDown(id, lparam, dparam, sparam);
        m_quickTLine.OnKeyDown(id, lparam, dparam, sparam);
        m_quickDelete.OnKeyDown(id, lparam, dparam, sparam);
        m_quickDeselect.OnKeyDown(id, lparam, dparam, sparam);
    }
    
    return true;
}

bool CAcemQuickEditManagement::OnMouseMove(int id, long lparam, double dparam, string sparam)
{
    m_quickCLine.OnMouseMove(id, lparam, dparam, sparam);
    m_quickHLine.OnMouseMove(id, lparam, dparam, sparam);
    m_quickVLine.OnMouseMove(id, lparam, dparam, sparam);
    m_quickTLine.OnMouseMove(id, lparam, dparam, sparam);
    m_quickDelete.OnMouseMove(id, lparam, dparam, sparam);
    m_quickDeselect.OnMouseMove(id, lparam, dparam, sparam);

    return true;
}

bool CAcemQuickEditManagement::OnObjectCreate(int id, long lparam, double dparam, string sparam)
{
    m_quickCLine.OnObjectCreate(id, lparam, dparam, sparam);
    m_quickHLine.OnObjectCreate(id, lparam, dparam, sparam);
    m_quickVLine.OnObjectCreate(id, lparam, dparam, sparam);
    m_quickTLine.OnObjectCreate(id, lparam, dparam, sparam);
    m_quickDelete.OnObjectCreate(id, lparam, dparam, sparam);
    m_quickDeselect.OnObjectCreate(id, lparam, dparam, sparam);

    return true;
}

bool CAcemQuickEditManagement::OnObjectChange(int id, long lparam, double dparam, string sparam)
{
    m_quickCLine.OnObjectChange(id, lparam, dparam, sparam);
    m_quickHLine.OnObjectChange(id, lparam, dparam, sparam);
    m_quickVLine.OnObjectChange(id, lparam, dparam, sparam);
    m_quickTLine.OnObjectChange(id, lparam, dparam, sparam);
    m_quickDelete.OnObjectChange(id, lparam, dparam, sparam);
    m_quickDeselect.OnObjectChange(id, lparam, dparam, sparam);

    return true;
}

bool CAcemQuickEditManagement::OnObjectDelete(int id, long lparam, double dparam, string sparam)
{
    m_quickCLine.OnObjectDelete(id, lparam, dparam, sparam);
    m_quickHLine.OnObjectDelete(id, lparam, dparam, sparam);
    m_quickVLine.OnObjectDelete(id, lparam, dparam, sparam);
    m_quickTLine.OnObjectDelete(id, lparam, dparam, sparam);
    m_quickDelete.OnObjectDelete(id, lparam, dparam, sparam);
    m_quickDeselect.OnObjectDelete(id, lparam, dparam, sparam);

    return true;
}

bool CAcemQuickEditManagement::OnChartClick(int id, long lparam, double dparam, string sparam)
{
    m_quickCLine.OnChartClick(id, lparam, dparam, sparam);
    m_quickHLine.OnChartClick(id, lparam, dparam, sparam);
    m_quickVLine.OnChartClick(id, lparam, dparam, sparam);
    m_quickTLine.OnChartClick(id, lparam, dparam, sparam);
    m_quickDelete.OnChartClick(id, lparam, dparam, sparam);
    m_quickDeselect.OnChartClick(id, lparam, dparam, sparam);

    return true;
}

bool CAcemQuickEditManagement::OnObjectClick(int id, long lparam, double dparam, string sparam)
{
    m_quickCLine.OnObjectClick(id, lparam, dparam, sparam);
    m_quickHLine.OnObjectClick(id, lparam, dparam, sparam);
    m_quickVLine.OnObjectClick(id, lparam, dparam, sparam);
    m_quickTLine.OnObjectClick(id, lparam, dparam, sparam);
    m_quickDelete.OnObjectClick(id, lparam, dparam, sparam);
    m_quickDeselect.OnObjectClick(id, lparam, dparam, sparam);

    return true;
}

bool CAcemQuickEditManagement::OnObjectDrag(int id, long lparam, double dparam, string sparam)
{
    m_quickCLine.OnObjectDrag(id, lparam, dparam, sparam);
    m_quickHLine.OnObjectDrag(id, lparam, dparam, sparam);
    m_quickVLine.OnObjectDrag(id, lparam, dparam, sparam);
    m_quickTLine.OnObjectDrag(id, lparam, dparam, sparam);
    m_quickDelete.OnObjectDrag(id, lparam, dparam, sparam);
    m_quickDeselect.OnObjectDrag(id, lparam, dparam, sparam);

    return true;
}

bool CAcemQuickEditManagement::OnObjectEndEdit(int id, long lparam, double dparam, string sparam)
{
    m_quickCLine.OnObjectEndEdit(id, lparam, dparam, sparam);
    m_quickHLine.OnObjectEndEdit(id, lparam, dparam, sparam);
    m_quickVLine.OnObjectEndEdit(id, lparam, dparam, sparam);
    m_quickTLine.OnObjectEndEdit(id, lparam, dparam, sparam);
    m_quickDelete.OnObjectEndEdit(id, lparam, dparam, sparam);
    m_quickDeselect.OnObjectEndEdit(id, lparam, dparam, sparam);

    return true;
}

bool CAcemQuickEditManagement::OnChartChange(int id, long lparam, double dparam, string sparam)
{
    m_quickCLine.OnChartChange(id, lparam, dparam, sparam);
    m_quickHLine.OnChartChange(id, lparam, dparam, sparam);
    m_quickVLine.OnChartChange(id, lparam, dparam, sparam);
    m_quickTLine.OnChartChange(id, lparam, dparam, sparam);
    m_quickDelete.OnChartChange(id, lparam, dparam, sparam);
    m_quickDeselect.OnChartChange(id, lparam, dparam, sparam);

    return true;
}

bool CAcemQuickEditManagement::isEditing()
{
    return  m_quickCLine.isEditing() || m_quickTLine.isEditing();
}
