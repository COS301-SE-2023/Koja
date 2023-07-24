package com.teamcaffeine.koja.repository

import com.teamcaffeine.koja.entity.TimeBoundary
import org.springframework.data.jpa.repository.JpaRepository

interface TimeBoundaryRepository : JpaRepository<TimeBoundary, Int>
