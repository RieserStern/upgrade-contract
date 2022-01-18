//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

abstract contract DateTimeHandle {
    /*
     *  Date and Time utilities for ethereum contracts
     *
     */
    struct DateTimeStruct {
        uint16 year;
        uint8 month;
        uint8 day;
    }

    uint private constant DAY_IN_SECONDS = 86400;
    uint private constant YEAR_IN_SECONDS = 31536000;
    uint private constant LEAP_YEAR_IN_SECONDS = 31622400;
    uint private constant HOUR_IN_SECONDS = 3600;
    uint private constant MINUTE_IN_SECONDS = 60;

    uint16 private constant ORIGIN_YEAR = 1970;
    
    /**
     * Is the LeapYear
     * @param year - check isLeapYear
     * @return true; LeapYear, fales; No LeapYear
     */
    function isLeapYear(uint16 year) internal pure returns (bool) {
        if (year % 4 != 0) {
            return false;
        }
        if (year % 100 != 0) {
            return true;
        }
        if (year % 400 != 0) {
            return false;
        }
        return true;
    }

    /**
     * Number of the LeapYears
     * @dev Get the count of LeapYear before the specific year
     */
    function leapYearsBefore(uint256 year) internal pure returns (uint256) {
        year -= 1;
        return year / 4 - year / 100 + year / 400;
    }
    
    /**
     * Days of the month
     * @dev Get the days of the specific month, year
     */
    function getDaysInMonth(uint8 month, uint16 year)
        internal
        pure
        returns (uint8)
    {
        if (
            month == 1 ||
            month == 3 ||
            month == 5 ||
            month == 7 ||
            month == 8 ||
            month == 10 ||
            month == 12
        ) {
            return 31;
        } else if (month == 4 || month == 6 || month == 9 || month == 11) {
            return 30;
        } else if (isLeapYear(year)) {
            return 29;
        } else {
            return 28;
        }
    }

    /**
     * Get Year, Month, Day
     * @dev Get year, month, day from the timestamp
     */
    function parseTimestamp(uint256 timestamp)
        internal
        pure
        returns (DateTimeStruct memory dt)
    {
        uint256 secondsAccountedFor = 0;
        uint256 buf;
        uint8 i;

        // Year
        dt.year = getYear(timestamp);
        buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);

        secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
        secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);

        // Month
        uint256 secondsInMonth;
        for (i = 1; i <= 12; i++) {
            secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
            if (secondsInMonth + secondsAccountedFor > timestamp) {
                dt.month = i;
                break;
            }
            secondsAccountedFor += secondsInMonth;
        }

        // Day
        for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
            if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
                dt.day = i;
                break;
            }
            secondsAccountedFor += DAY_IN_SECONDS;
        }
    }

    /**
     * Year from timestamp
     * @dev Get Year from the timestamp
     */
    function getYear(uint256 timestamp) internal pure returns (uint16) {
        uint256 secondsAccountedFor = 0;
        uint16 year;
        uint256 numLeapYears;

        // Year
        year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
        numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);

        secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
        secondsAccountedFor +=
            YEAR_IN_SECONDS *
            (year - ORIGIN_YEAR - numLeapYears);

        while (secondsAccountedFor > timestamp) {
            if (isLeapYear(uint16(year - 1))) {
                secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
            } else {
                secondsAccountedFor -= YEAR_IN_SECONDS;
            }
            year -= 1;
        }
        return year;
    }

    /**
     * Month from timestamp
     * @dev Get Month from the timestamp
     */
    function getMonth(uint256 timestamp) internal pure returns (uint8) {
        return parseTimestamp(timestamp).month;
    }

    /**
     * Day from timestamp
     * @dev Get Day from the timestamp
     */
    function getDay(uint256 timestamp) internal pure returns (uint8) {
        return parseTimestamp(timestamp).day;
    }

}