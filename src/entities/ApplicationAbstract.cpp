//
// Created by alexis on 7/4/18.
//

#include "ApplicationAbstract.h"
std::ostream& operator<<(std::ostream& os, const ApplicationAbstract& abstract)
{
    os << "id: " << abstract.id.toStdString() << " icon: " << abstract.icon.toStdString()
       << " name: " << abstract.name << " abstract: " << abstract.abstract
       << " fileSize: " << abstract.fileSize
       << " latestReleaseVersion: " << abstract.latestReleaseVersion.toStdString();
    return os;
}
ApplicationAbstract::ApplicationAbstract()
        :fileSize(0) { }